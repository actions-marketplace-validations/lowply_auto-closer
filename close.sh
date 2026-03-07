#!/bin/bash
set -euo pipefail

label="${1:?label is required}"
keep="${2:-1}"

if [[ "$keep" -lt 1 ]]; then
  echo "::error::keep must be at least 1"
  exit 1
fi

echo "Finding open issues with label: ${label}"

repo="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required}"

issues=$(gh issue list \
  --repo "$repo" \
  --label "$label" \
  --state open \
  --limit 999 \
  --json number,title \
  --jq '.[].number')

count=$(echo "$issues" | grep -c . || true)

if [[ "$count" -eq 0 ]]; then
  echo "No open issues found with label: ${label}"
  exit 0
fi

if [[ "$count" -le "$keep" ]]; then
  echo "Only ${count} open issue(s) found, keeping all (keep=${keep})"
  exit 0
fi

to_close=$(echo "$issues" | tail -n +"$((keep + 1))")

echo "Closing $((count - keep)) issue(s), keeping newest ${keep}"

for number in $to_close; do
  echo "Closing issue #${number}"
  gh issue close "$number" --repo "$repo"
done
