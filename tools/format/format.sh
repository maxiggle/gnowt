#!/usr/bin/env bash
# The one entry point for formatting. format_check.sh is its read-only twin.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
source tools/format/source_files.sh

dart_files=()
while IFS= read -r source_file; do dart_files+=("$source_file"); done \
  < <(list_source_files_with_extension dart)
if ((${#dart_files[@]})); then
  require_formatter dart "install Flutter (it bundles Dart)"
  dart format "${dart_files[@]}"
fi

swift_files=()
while IFS= read -r source_file; do swift_files+=("$source_file"); done \
  < <(list_source_files_with_extension swift)
if ((${#swift_files[@]})); then
  run_swift_format format --in-place "${swift_files[@]}"
fi

kotlin_files=()
while IFS= read -r source_file; do kotlin_files+=("$source_file"); done \
  < <(list_source_files_with_extension kt)
if ((${#kotlin_files[@]})); then
  require_formatter ktlint "brew install ktlint"
  ktlint --format "${kotlin_files[@]}"
fi

gno_files=()
while IFS= read -r source_file; do gno_files+=("$source_file"); done \
  < <(list_source_files_with_extension gno)
if ((${#gno_files[@]})); then
  require_formatter gno "make install in a gnolang/gno checkout"
  gno fmt -w "${gno_files[@]}"
fi
