#!/bin/bash
# Archive old next-session prompt files to _legacy/
#
# Usage: ./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md

set -euo pipefail

KEEP_FILE=""
NEXT_SESSION_DIR="handover/next_session"
LEGACY_DIR="_legacy/handover/next_session"

while [[ $# -gt 0 ]]; do
  case $1 in
    --keep)
      KEEP_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 --keep handover/next_session/YYYY-MM-DD-N.md"
      exit 1
      ;;
  esac
done

if [ -z "$KEEP_FILE" ]; then
  echo "Error: --keep argument is required"
  echo "Usage: $0 --keep handover/next_session/YYYY-MM-DD-N.md"
  exit 1
fi

# Create legacy directory if needed
mkdir -p "$LEGACY_DIR"

# Find dated files (pattern: YYYY-MM-DD-N.md) and move all except the keep file
MOVED=0
for f in "$NEXT_SESSION_DIR"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.md; do
  [ -f "$f" ] || continue
  if [ "$f" != "$KEEP_FILE" ]; then
    mv "$f" "$LEGACY_DIR/"
    echo "Moved: $f -> $LEGACY_DIR/"
    MOVED=$((MOVED + 1))
  fi
done

if [ "$MOVED" -eq 0 ]; then
  echo "No files to archive."
else
  echo "Archived $MOVED file(s)."
fi
