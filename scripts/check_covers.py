#!/bin/python

import os
import argparse

# Supported audio extensions to identify an "album" folder
AUDIO_EXTENSIONS = {'.mp3', '.flac', '.m4a', '.wav', '.ogg', '.opus', '.wma', '.aac'}
# Supported image extensions for covers
IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png'}

def scan_library(root_dir):
    total_albums = 0
    albums_missing_covers = []

    print(f"Scanning: {root_dir}\n" + "-"*40)

    # os.walk goes through all directories and subdirectories recursively
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Check if the current folder contains any audio files
        is_album = any(os.path.splitext(f)[1].lower() in AUDIO_EXTENSIONS for f in filenames)

        if is_album:
            total_albums += 1
            
            # Check if the current folder contains any image files
            has_cover = any(os.path.splitext(f)[1].lower() in IMAGE_EXTENSIONS for f in filenames)

            if not has_cover:
                # Get the path relative to the root directory for cleaner output
                relative_path = os.path.relpath(dirpath, root_dir)
                albums_missing_covers.append(relative_path)

    # --- Output Results ---
    print("-" * 40)
    print(f"Total albums found: {total_albums}")
    
    if not albums_missing_covers:
        print("✅ Great news! All albums have cover art.")
    else:
        print(f"❌ Found {len(albums_missing_covers)} albums missing covers:\n")
        for album_path in albums_missing_covers:
            print(f"  - {album_path}")

if __name__ == "__main__":
    # Set up command line argument parsing
    parser = argparse.ArgumentParser(description="Check music library for missing album covers.")
    parser.add_argument(
        "library_path", 
        help="Path to your music library folder"
    )
    
    args = parser.parse_args()

    # Verify the path exists before running
    if os.path.isdir(args.library_path):
        scan_library(args.library_path)
    else:
        print(f"Error: The directory '{args.library_path}' does not exist.")
