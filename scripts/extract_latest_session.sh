#!/bin/bash
# Extract the latest session implementation block from handover_memo_latest.md
# and append it to handover_memo_archived.md
#
# Usage: bash scripts/extract_latest_session.sh

set -euo pipefail

LATEST="handover/handover_memo_latest.md"
ARCHIVED="handover/handover_memo_archived.md"

if [ ! -f "$LATEST" ]; then
  echo "Error: $LATEST not found"
  exit 1
fi

if [ ! -f "$ARCHIVED" ]; then
  echo "Error: $ARCHIVED not found"
  exit 1
fi

# Extract the "## 実装状況" section (everything between "## 実装状況" and the next "## " or end of file)
SECTION=$(sed -n '/^## 実装状況/,/^## [^実]/{ /^## [^実]/d; p; }' "$LATEST")

if [ -z "$SECTION" ]; then
  echo "No '## 実装状況' section found in $LATEST. Nothing to extract."
  exit 0
fi

# Append to archived with a separator
echo "" >> "$ARCHIVED"
echo "---" >> "$ARCHIVED"
echo "" >> "$ARCHIVED"
echo "$SECTION" >> "$ARCHIVED"

echo "Extracted '## 実装状況' section from $LATEST to $ARCHIVED"

# Remove the section from latest
# Using a temp file for portability
TMPFILE=$(mktemp)
sed '/^## 実装状況/,/^## [^実]/{/^## [^実]/!d;}' "$LATEST" > "$TMPFILE"
mv "$TMPFILE" "$LATEST"

echo "Removed '## 実装状況' section from $LATEST"
