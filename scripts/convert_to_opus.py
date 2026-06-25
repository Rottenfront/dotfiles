#!/bin/python

import os
import sys
import shutil
import subprocess
import argparse
from concurrent.futures import ProcessPoolExecutor, as_completed

# Supported inputs
AUDIO_EXTENSIONS = {'.flac', '.mp3'}
IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png'}

# Globals for ImageMagick commands (initialized per worker process)
IM_BASE = None
IM_IDENTIFY = None


def init_worker():
    """Initialize ImageMagick paths for each worker process."""
    global IM_BASE, IM_IDENTIFY
    if shutil.which('magick'):
        IM_BASE = 'magick'
        IM_IDENTIFY = ['magick', 'identify']
    elif shutil.which('convert'):
        IM_BASE = 'convert'
        IM_IDENTIFY = ['identify']
    else:
        print("Error: ImageMagick not found in worker.", file=sys.stderr)
        sys.exit(1)


def check_dependencies(push_covers):
    """Check if ffmpeg, opusenc, and (optionally) ImageMagick are installed."""
    if not shutil.which('ffmpeg'):
        sys.exit("Error: 'ffmpeg' is not installed or not in PATH.")
    if not shutil.which('opusenc'):
        sys.exit("Error: 'opusenc' (opus-tools) is not installed or not in PATH.")
    if push_covers and not shutil.which('magick') and not shutil.which('convert'):
        sys.exit(
            "Error: ImageMagick ('magick' or 'convert') is not installed or not in PATH.")


def process_image(source_file, dest_dir):
    """Process cover art: convert PNG to JPG (90%), resize if > 1000x1000."""
    ext = os.path.splitext(source_file)[1].lower()
    base_name = os.path.splitext(os.path.basename(source_file))[0]
    dest_file = os.path.join(dest_dir, base_name + '.jpg')

    # 1. If it's a PNG, always convert to JPG with 90% quality and enforce size limit
    if ext == '.png':
        cmd = [IM_BASE, source_file, '-resize',
               '1000x1000>', '-quality', '90', dest_file]
        subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL,
                       stderr=subprocess.PIPE)
        return dest_file

    # 2. If it's already a JPG, check dimensions
    elif ext in ('.jpg', '.jpeg'):
        id_cmd = IM_IDENTIFY + ['-format', '%w %h', source_file]
        try:
            result = subprocess.run(
                id_cmd, capture_output=True, text=True, check=True)
            w, h = map(int, result.stdout.strip().split())

            # If too large, resize and re-encode
            if w > 1000 or h > 1000:
                cmd = [IM_BASE, source_file,
                       '-resize', '1000x1000>', dest_file]
                subprocess.run(
                    cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
            else:
                # Small enough, just copy it directly to avoid quality loss
                shutil.copy2(source_file, dest_file)
        except Exception:
            # Fallback to simple copy if ImageMagick identify fails
            shutil.copy2(source_file, dest_file)

        return dest_file

    return None


def process_track(input_file, output_file, cover_path):
    """Decode with ffmpeg (stripping ReplayGain), pipe to opusenc to encode and embed cover."""

    ffmpeg_cmd = [
        'ffmpeg', '-nostdin', '-i', input_file,
        '-map_metadata', '0',
        '-c:a', 'flac', '-compression_level', '5',
        '-metadata', 'REPLAYGAIN_TRACK_GAIN=',
        '-metadata', 'REPLAYGAIN_TRACK_PEAK=',
        '-metadata', 'REPLAYGAIN_ALBUM_GAIN=',
        '-metadata', 'REPLAYGAIN_ALBUM_PEAK=',
        '-metadata', 'R128_TRACK_GAIN=',
        '-metadata', 'R128_ALBUM_GAIN=',
        '-f', 'flac', 'pipe:1'
    ]

    opusenc_cmd = [
        'opusenc', '--bitrate', '160'
    ]
    if cover_path:
        opusenc_cmd.extend(['--picture', cover_path])
    opusenc_cmd.extend(['-', output_file])

    try:
        ffmpeg_proc = subprocess.Popen(
            ffmpeg_cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        opusenc_proc = subprocess.Popen(
            opusenc_cmd, stdin=ffmpeg_proc.stdout, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)

        ffmpeg_proc.stdout.close()
        _, err = opusenc_proc.communicate()
        ffmpeg_proc.wait()

        if opusenc_proc.returncode != 0:
            print(f"    [ERROR] opusenc failed on {os.path.basename(input_file)}: {
                  err.decode(errors='ignore').strip()}", flush=True)
            if os.path.exists(output_file):
                os.remove(output_file)
            return False

        return True

    except Exception as e:
        print(f"    [ERROR] Exception during conversion of {
              os.path.basename(input_file)}: {e}", flush=True)
        return False


def process_album(input_dir, output_dir, filenames, rel_dir, push_covers, force):
    """Processes all images and audio files for a single album folder."""
    os.makedirs(output_dir, exist_ok=True)

    # 1. Process all covers in the directory first (only if push_covers is enabled)
    local_cover = None
    if push_covers:
        for filename in filenames:
            ext = os.path.splitext(filename)[1].lower()
            if ext in IMAGE_EXTENSIONS:
                source_image = os.path.join(input_dir, filename)
                dest_image = os.path.join(
                    output_dir, os.path.splitext(filename)[0] + '.jpg')

                # Skip image processing if it already exists and we're not forcing
                if not force and os.path.exists(dest_image):
                    if not local_cover:
                        local_cover = dest_image
                    continue

                try:
                    processed_image = process_image(source_image, output_dir)
                    # Save the first processed image path to use for embedding
                    if processed_image and not local_cover:
                        local_cover = processed_image
                except subprocess.CalledProcessError as e:
                    print(f"    [WARNING] Failed to process image {filename}: {
                          e.stderr.decode(errors='ignore').strip()}", flush=True)

    # 2. Convert audio files
    total = 0
    converted = 0
    skipped = 0

    for filename in filenames:
        ext = os.path.splitext(filename)[1].lower()

        if ext in AUDIO_EXTENSIONS:
            total += 1

            input_file = os.path.join(input_dir, filename)
            out_filename = os.path.splitext(filename)[0] + '.opus'
            output_file = os.path.join(output_dir, out_filename)

            # Skip audio processing if it already exists and we're not forcing
            if not force and os.path.exists(output_file):
                skipped += 1
                print(f"[SKIP]    {os.path.join(
                    rel_dir, out_filename)} (already exists)", flush=True)
                continue

            # Only embed a cover if push_covers is enabled
            cover_for_track = local_cover if push_covers else None
            success = process_track(input_file, output_file, cover_for_track)
            if success:
                converted += 1
                print(f"[CONVERT] {os.path.join(
                    rel_dir, filename)} -> {out_filename}", flush=True)
            else:
                print(f"[FAILED]  {os.path.join(
                    rel_dir, filename)}", flush=True)

    return total, converted, skipped


def main():
    parser = argparse.ArgumentParser(
        description="Re-encode music to Opus 160k, strip ReplayGain, process covers, and embed them. (Multiprocessing)"
    )
    parser.add_argument("input_dir", help="Path to your input music library")
    parser.add_argument(
        "output_dir", help="Path to the new Opus music library")
    parser.add_argument(
        "--cover",
        action="store_true",
        help="Enable cover art processing and embedding into Opus files."
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Re-encode and overwrite existing files instead of skipping them."
    )
    args = parser.parse_args()

    check_dependencies(args.cover)

    input_dir = os.path.abspath(args.input_dir)
    output_dir = os.path.abspath(args.output_dir)

    if not os.path.isdir(input_dir):
        sys.exit(f"Error: Input directory '{input_dir}' does not exist.")

    # Gather all album directories to process
    tasks = []
    for dirpath, dirnames, filenames in os.walk(input_dir):
        # Only queue folders that actually contain audio files
        if any(os.path.splitext(f)[1].lower() in AUDIO_EXTENSIONS for f in filenames):
            rel_dir = os.path.relpath(dirpath, input_dir)
            out_dir = os.path.join(output_dir, rel_dir)
            tasks.append((dirpath, out_dir, filenames, rel_dir))

    total_tasks = len(tasks)
    cpu_count = os.cpu_count()

    print(f"Source: {input_dir}")
    print(f"Destination: {output_dir}")
    print(f"Found {total_tasks} albums to process.")
    print(f"Cover pushing: {'ENABLED' if args.cover else 'DISABLED'}")
    print(f"Overwrite mode: {
          'ENABLED (--force)' if args.force else 'DISABLED (skipping existing)'}")
    print(f"Utilizing {cpu_count} CPU cores...\n" + "-"*40)

    total_files = 0
    converted_files = 0
    skipped_files = 0
    completed_tasks = 0

    # Use ProcessPoolExecutor to spread albums across all CPU cores
    with ProcessPoolExecutor(max_workers=cpu_count, initializer=init_worker) as executor:
        futures = [
            executor.submit(
                process_album, task[0], task[1], task[2], task[3], args.cover, args.force)
            for task in tasks
        ]

        for future in as_completed(futures):
            try:
                tot, conv, skp = future.result()
                total_files += tot
                converted_files += conv
                skipped_files += skp
                completed_tasks += 1
                print(f"[PROGRESS] {
                      completed_tasks}/{total_tasks} albums finished.", flush=True)
            except Exception as e:
                print(f"[ERROR] An album failed to process entirely: {
                      e}", flush=True)

    print("-" * 40)
    print(f"Done! Converted: {converted_files} | Skipped (existing): {
          skipped_files} | Total processed: {total_files}")


if __name__ == "__main__":
    main()
