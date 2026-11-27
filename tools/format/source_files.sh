#!/usr/bin/env bash
# Shared by format.sh and format_check.sh so both always cover the same files.
# Uses git's file list so build output and other ignored files are skipped.

# Prints tracked and untracked-but-not-ignored files with the given extension.
list_source_files_with_extension() {
  local extension="$1"
  git ls-files --cached --others --exclude-standard -- "*.${extension}" |
    while IFS= read -r source_file; do
      [[ -f "$source_file" ]] && printf '%s\n' "$source_file"
    done
}

# Exits with a message naming the missing formatter and how to install it.
require_formatter() {
  local formatter_command="$1"
  local install_hint="$2"
  if ! command -v "$formatter_command" >/dev/null 2>&1; then
    echo "error: '$formatter_command' not found. Install it: $install_hint" >&2
    exit 1
  fi
}

# swift-format ships inside Xcode on macOS and as a standalone binary elsewhere.
run_swift_format() {
  if command -v swift-format >/dev/null 2>&1; then
    swift-format "$@"
  elif command -v xcrun >/dev/null 2>&1 && xcrun --find swift-format >/dev/null 2>&1; then
    xcrun swift-format "$@"
  else
    echo "error: 'swift-format' not found. Install Xcode or swift-format." >&2
    exit 1
  fi
}
