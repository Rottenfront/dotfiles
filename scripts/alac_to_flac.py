#!/usr/bin/env python3
###############################################################################
# ALAC to FLAC Recursive Converter (Preserve Artwork As-Is)
#
# Usage: python3 alac_to_flac.py /path/to/source /path/to/destination
#
# Features:
# 1. Preserves embedded cover art from source ALAC files
# 2. Copies external artwork files as-is (folder.jpg, cover.png, etc.)
# 3. Uses multiprocessing for faster conversion
# 4. Preserves all metadata/tags
# 5. Skips files if FLAC version already exists
###############################################################################

import os
import sys
import subprocess
import multiprocessing as mp
from pathlib import Path
from typing import Tuple, List
from datetime import datetime
from concurrent.futures import ProcessPoolExecutor, as_completed

# --- Configuration ---
# Common external artwork filenames to copy as-is
ARTWORK_NAMES = [
    'folder.jpg', 'folder.jpeg', 'folder.png', 'folder.gif', 'folder.webp',
    'cover.jpg', 'cover.jpeg', 'cover.png', 'cover.gif', 'cover.webp',
    'album.jpg', 'album.jpeg', 'album.png', 'album.gif', 'album.webp',
    'art.jpg', 'art.jpeg', 'art.png', 'art.gif', 'art.webp',
    'front.jpg', 'front.jpeg', 'front.png', 'front.gif', 'front.webp',
    'back.jpg', 'back.jpeg', 'back.png',
    'disc.jpg', 'disc.jpeg', 'disc.png',
    'cd.jpg', 'cd.jpeg', 'cd.png'
]

# Number of parallel conversions (0 = auto-detect CPU cores)
NUM_WORKERS = 0

# --- Helper Functions ---


def get_available_cpus() -> int:
    """Return the number of available CPU cores."""
    return mp.cpu_count() or 1


def find_artwork_files(directory: Path) -> List[Path]:
    """
    Find all external artwork files in the given directory.
    Returns a list of paths to artwork files.
    """
    artwork_files = []

    if not directory.exists() or not directory.is_dir():
        return artwork_files

    for file in directory.iterdir():
        if file.is_file() and file.name.lower() in [name.lower() for name in ARTWORK_NAMES]:
            artwork_files.append(file)
        # Also check for common image extensions in case of non-standard names
        elif file.is_file() and file.suffix.lower() in ['.jpg', '.jpeg', '.png', '.gif', '.webp']:
            # Check if filename contains common artwork keywords
            name_lower = file.name.lower()
            if any(keyword in name_lower for keyword in ['folder', 'cover', 'album', 'art', 'front', 'back', 'disc']):
                artwork_files.append(file)

    return artwork_files


def copy_artwork_files(source_dir: Path, dest_dir: Path) -> Tuple[int, int]:
    """
    Copy all external artwork files from source to destination directory.
    Returns: (copied_count, skipped_count)
    """
    copied = 0
    skipped = 0

    artwork_files = find_artwork_files(source_dir)

    for artwork_file in artwork_files:
        dest_artwork = dest_dir / artwork_file.name

        if dest_artwork.exists():
            skipped += 1
            continue

        try:
            dest_dir.mkdir(parents=True, exist_ok=True)
            subprocess.run(
                ['cp', str(artwork_file), str(dest_artwork)], check=True)
            copied += 1
        except Exception as e:
            print(
                f"\033[31mFAIL: Could not copy {artwork_file.name}: {e}\033[0m")

    return copied, skipped


def convert_file(args: Tuple[str, str, bool]) -> Tuple[str, bool, str]:
    """
    Convert a single ALAC file to FLAC.
    Returns: (filename, success, message)
    """
    input_file, output_file, mirror_mode = args

    input_path = Path(input_file)
    output_path = Path(output_file)

    # Check if output already exists
    if output_path.exists():
        return (input_path.name, True, "SKIP (already exists)")

    # Create destination directory if needed
    if mirror_mode:
        output_path.parent.mkdir(parents=True, exist_ok=True)

    # Build ffmpeg command
    # -map 0: Include all streams (audio + embedded cover art)
    # -map_metadata 0: Copy all metadata tags
    # -copy_unknown: Preserve unknown metadata blocks
    cmd = [
        'ffmpeg',
        '-loglevel', 'error',
        '-i', str(input_file),
        '-map', '0',
        '-c:a', 'flac',
        '-map_metadata', '0',
        '-copy_unknown',
        str(output_file)
    ]

    # Execute conversion
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=300  # 5 minute timeout per file
        )

        if result.returncode == 0:
            return (input_path.name, True, "OK")
        else:
            error_msg = result.stderr.strip(
            )[:100] if result.stderr else "Unknown error"
            return (input_path.name, False, f"FAIL: {error_msg}")

    except subprocess.TimeoutExpired:
        return (input_path.name, False, "FAIL: Timeout")
    except Exception as e:
        return (input_path.name, False, f"FAIL: {str(e)}")


def process_album_dir(args: Tuple[str, str, bool]) -> Tuple[int, int, int, int]:
    """
    Process a single album directory: convert audio files and copy artwork.
    Returns: (total, converted, skipped, failed)
    """
    source_dir, dest_dir, mirror_mode = args

    source_path = Path(source_dir)
    dest_path = Path(dest_dir)

    total = 0
    converted = 0
    skipped = 0
    failed = 0

    # Find all ALAC files in this directory
    m4a_files = list(source_path.glob('*.m4a'))
    total = len(m4a_files)

    # Prepare conversion tasks
    tasks = []
    for m4a_file in m4a_files:
        rel_path = m4a_file.relative_to(source_path.parent)
        output_file = dest_path.parent / rel_path.with_suffix('.flac')
        tasks.append((str(m4a_file), str(output_file), mirror_mode))

    # Convert audio files
    for input_file, output_file, mode in tasks:
        filename, success, message = convert_file(
            (input_file, output_file, mode))
        if "SKIP" in message:
            skipped += 1
        elif success:
            converted += 1
        else:
            failed += 1

    # Copy external artwork files
    art_copied, art_skipped = copy_artwork_files(source_path, dest_path)

    return (total, converted, skipped + art_skipped, failed)


def main():
    # --- Argument Validation ---
    if len(sys.argv) < 2:
        print(
            "Usage: python3 alac_to_flac.py <source_directory> [destination_directory]")
        print("")
        print(
            "If destination is omitted, FLAC files will be created alongside the originals.")
        sys.exit(1)

    # Check ffmpeg
    try:
        subprocess.run(['ffmpeg', '-version'], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("ERROR: ffmpeg could not be found. Please install it first.")
        sys.exit(1)

    source_dir = Path(sys.argv[1]).resolve()

    if len(sys.argv) == 3:
        dest_dir = Path(sys.argv[2]).resolve()
        mirror_mode = True
    else:
        dest_dir = source_dir
        mirror_mode = False
        print("NOTE: No destination provided. Outputting FLAC files to source directory.")

    if not source_dir.exists() or not source_dir.is_dir():
        print(f"ERROR: Source directory '{source_dir}' does not exist.")
        sys.exit(1)

    # --- Find All Album Directories ---
    print("Scanning for album directories...")

    # Find all directories that contain .m4a files
    album_dirs = set()
    for m4a_file in source_dir.rglob('*.m4a'):
        album_dirs.add(m4a_file.parent)

    album_dirs = sorted(album_dirs)

    if not album_dirs:
        print("No .m4a files found in the source directory.")
        sys.exit(0)

    print(f"Found {len(album_dirs)} album directory(s)")
    print(f"Source: {source_dir}")
    print(f"Destination: {dest_dir}")
    workers = NUM_WORKERS if NUM_WORKERS > 0 else get_available_cpus()
    print(f"Workers: {workers} ({get_available_cpus()} CPUs available)")
    print("-" * 60)

    # --- Prepare Album Processing Tasks ---
    tasks = []
    for album_dir in album_dirs:
        rel_path = album_dir.relative_to(source_dir)
        dest_album_dir = dest_dir / rel_path
        tasks.append((str(album_dir), str(dest_album_dir), mirror_mode))

    # --- Process Albums in Parallel ---
    count_total = 0
    count_converted = 0
    count_skipped = 0
    count_failed = 0

    start_time = datetime.now()

    with ProcessPoolExecutor(max_workers=workers) as executor:
        futures = {executor.submit(
            process_album_dir, task): task for task in tasks}

        for future in as_completed(futures):
            source_dir_task, dest_dir_task, _ = futures[future]
            try:
                total, converted, skipped, failed = future.result()
                count_total += total
                count_converted += converted
                count_skipped += skipped
                count_failed += failed

                album_name = Path(source_dir_task).name
                print(
                    f"\033[36mProcessed: {album_name}\033[0m ({converted} converted, {skipped} skipped, {failed} failed)")

            except Exception as e:
                print(
                    f"\033[31mERROR processing {source_dir_task}: {e}\033[0m")
                count_failed += 1

    end_time = datetime.now()
    duration = end_time - start_time

    # --- Summary ---
    print("-" * 60)
    print("Conversion Complete.")
    print(f"Total Files:    {count_total}")
    print(f"Converted:      {count_converted}")
    print(f"Skipped:        {count_skipped}")
    print(f"Failed:         {count_failed}")
    print(f"Duration:       {duration}")

    if count_failed > 0:
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == '__main__':
    main()
