#!/usr/bin/env bash
# Runs the tests of every module a commit touches, for each commit in a range,
# so a broken intermediate commit fails review.
#
# Usage: tools/ci/test_each_commit.sh <base-commit> <head-commit>
#
# CI copies this script out of the checkout first, because it checks out
# older commits while it runs.
set -euo pipefail

base_commit="$1"
head_commit="$2"
module_registry="tools/ci/modules.tsv"

# Root config and tooling affect every module, so they trigger all tests.
is_change_affecting_all_modules() {
  local changed_path="$1"
  [[ "$changed_path" != */* ]] || [[ "$changed_path" == tools/* ]]
}

list_modules_to_test_at_commit() {
  local commit="$1"
  [[ -f "$module_registry" ]] || return 0
  local changed_paths
  changed_paths="$(git diff-tree --no-commit-id --name-only -r --root "$commit")"
  local should_test_all_modules=false
  while IFS= read -r changed_path; do
    if is_change_affecting_all_modules "$changed_path"; then
      should_test_all_modules=true
    fi
  done <<<"$changed_paths"

  { grep -v '^#' "$module_registry" || true; } | while IFS=$'\t' read -r module_path test_command; do
    [[ -n "$module_path" ]] || continue
    if $should_test_all_modules || grep -q "^${module_path}/" <<<"$changed_paths"; then
      printf '%s\t%s\n' "$module_path" "$test_command"
    fi
  done
}

for commit in $(git rev-list --reverse "${base_commit}..${head_commit}"); do
  echo "::group::$(git log --format='%h %s' -n1 "$commit")"
  git checkout --quiet "$commit"
  modules_to_test="$(list_modules_to_test_at_commit "$commit")"
  if [[ -z "$modules_to_test" ]]; then
    echo "no module tests affected"
  else
    flutter pub get
    while IFS=$'\t' read -r module_path test_command; do
      echo "testing ${module_path}: ${test_command}"
      (cd "$module_path" && eval "$test_command")
    done <<<"$modules_to_test"
  fi
  echo "::endgroup::"
done
