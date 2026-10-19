#!/usr/bin/env python3
"""Review and copy NixOS configuration files.

Every ``.nix`` file below the source directory is compared with the file at
the same relative path below the target directory. All files must be approved
before any ``sudo cp`` command is run. With ``--omit-unchanged``, identical
files are skipped during review and copying.
"""

from __future__ import annotations

import argparse
import difflib
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


APPROVE_ANSWERS = {"a", "approve", "approved", "y", "yes"}
DENY_ANSWERS = {"d", "deny", "n", "no"}


def read_lines(path: Path) -> list[str]:
    """Read a text file while preserving line endings for the diff."""
    return path.read_text(encoding="utf-8", errors="surrogateescape").splitlines(
        keepends=True
    )


def make_diff(source: Path, target: Path, relative_path: Path) -> list[str]:
    """Return a unified diff, or an empty list when both files are equal."""
    source_lines = read_lines(source)
    target_lines = read_lines(target) if target.exists() else []

    return list(
        difflib.unified_diff(
            target_lines,
            source_lines,
            fromfile=f"/etc/nixos/{relative_path}",
            tofile=f"./{relative_path}",
        )
    )


def show_nvim_diff(source: Path, target: Path, relative_path: Path) -> bool:
    """Show a diff in nvim using temporary copies, leaving real files untouched."""
    try:
        with tempfile.TemporaryDirectory(prefix="sync-nixos-") as temporary:
            temporary_root = Path(temporary)
            temporary_source = temporary_root / "source" / relative_path
            temporary_target = temporary_root / "target" / relative_path
            temporary_source.parent.mkdir(parents=True)
            temporary_target.parent.mkdir(parents=True)

            shutil.copyfile(source, temporary_source)
            if target.exists():
                shutil.copyfile(target, temporary_target)
            else:
                temporary_target.touch()

            print(
                "Opening nvim diff (left: target, right: source). "
                "Temporary copies are used for review."
            )
            result = subprocess.run(
                ["nvim", "-d", "-R", str(temporary_target), str(temporary_source)],
                check=False,
            )
    except FileNotFoundError:
        print("nvim was not found; install it or omit --nvim-diff.", file=sys.stderr)
        return False
    except OSError as error:
        print(f"Could not start nvim: {error}", file=sys.stderr)
        return False

    if result.returncode != 0:
        print(f"nvim exited with status {result.returncode}.", file=sys.stderr)
        return False
    return True


def ask_for_approval(
    source: Path,
    target: Path,
    relative_path: Path,
    use_nvim_diff: bool,
) -> bool:
    """Show one file's review and return whether it was approved."""
    print(f"\n=== {relative_path} ===")

    if not target.exists():
        print(f"Target does not exist: {target}")

    if use_nvim_diff:
        if not show_nvim_diff(source, target, relative_path):
            return False
    else:
        diff_lines = make_diff(source, target, relative_path)
        if diff_lines:
            print(
                "".join(diff_lines),
                end="" if diff_lines[-1].endswith("\n") else "\n",
            )
        else:
            print("No differences.")

    while True:
        try:
            answer = input("Approve this file? [approve/deny]: ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print("\nReview cancelled; no files were copied.")
            return False

        if answer in APPROVE_ANSWERS:
            return True
        if answer in DENY_ANSWERS:
            print("File denied; no files were copied.")
            return False
        print("Please answer 'approve' or 'deny'.")


def copy_files(files: list[tuple[Path, Path]]) -> int:
    """Create missing target directories and copy approved files with sudo."""
    created_directories: set[Path] = set()

    try:
        for source, target in files:
            parent = target.parent
            if parent not in created_directories and not parent.is_dir():
                subprocess.run(["sudo", "mkdir", "-p", str(parent)], check=True)
                created_directories.add(parent)

            print(f"Copying {source} -> {target}")
            subprocess.run(["sudo", "cp", "--", str(source), str(target)], check=True)
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"Copy failed: {error}", file=sys.stderr)
        return 1

    print(f"Copied {len(files)} file(s).")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Review every .nix file and copy all approved files."
    )
    parser.add_argument(
        "--nvim-diff",
        action="store_true",
        help="review each file with nvim -d instead of the built-in unified diff",
    )
    parser.add_argument(
        "--omit-unchanged",
        action="store_true",
        help="skip review and copying for files identical to their targets",
    )
    parser.add_argument(
        "source",
        nargs="?",
        default=".",
        help="source directory (default: .)",
    )
    parser.add_argument(
        "target",
        nargs="?",
        default="/etc/nixos",
        help="target directory (default: /etc/nixos)",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    source_root = Path(args.source).expanduser().resolve()
    target_root = Path(args.target).expanduser().resolve()

    if not source_root.is_dir():
        print(f"Source directory does not exist: {source_root}", file=sys.stderr)
        return 1

    source_files = sorted(path for path in source_root.rglob("*.nix") if path.is_file())
    if not source_files:
        print(f"No .nix files found below {source_root}", file=sys.stderr)
        return 1

    files_to_copy: list[tuple[Path, Path]] = []
    for source in source_files:
        relative_path = source.relative_to(source_root)
        target = target_root / relative_path

        if (
            args.omit_unchanged
            and target.exists()
            and source.read_bytes() == target.read_bytes()
        ):
            continue

        if not ask_for_approval(source, target, relative_path, args.nvim_diff):
            return 1
        files_to_copy.append((source, target))

    if not files_to_copy:
        print("No changed files to copy.")
        return 0

    print("\nAll files approved. Starting copies.")
    return copy_files(files_to_copy)


if __name__ == "__main__":
    raise SystemExit(main())
