#!/usr/bin/env bash
# submit-issue.sh - Phase 1 completion: submits issue_open.md to ai/workflow_issue branch
#
# Overview:
#   After a human writes docs/issues/issue_open.md, this script sends it to
#   the ai/workflow_issue branch in a state that an AI agent can process.
#   It resets ai/workflow_issue to origin/main's base, then commits and pushes
#   only issue_open.md (a clean submission).
#
# Usage:
#   ./handover/scripts/submit-issue.sh [OPTIONS]
#
# Options:
#   --dry-run    Display the plan without writing or performing git operations
#   --help       Show help
#
# Examples:
#   # Standard run
#   ./handover/scripts/submit-issue.sh
#
#   # Dry-run to preview
#   ./handover/scripts/submit-issue.sh --dry-run
#
# Prerequisites:
#   - docs/issues/issue_open.md must be filled in (not in template state)
#   - You must have push access to origin
#   - Current directory must be the repository root (works from any branch)
#
# Notes:
#   - The ai/workflow_issue branch will be hard-reset to origin/main
#   - Any non-issue_open.md branch-specific changes will be lost (backup recommended)
#   - If you want the AI agent to read files other than issue_open.md (e.g., memo/*.md),
#     commit them to main first, or add them manually after the AI session starts

set -euo pipefail

# ========================================
# Utility functions
# ========================================

if [ -t 1 ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
  CYAN='\033[0;36m'; NC='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; NC=''
fi

info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ========================================
# Argument parsing
# ========================================

DRY_RUN=false

show_help() {
  # Display leading comments (lines starting with #)
  sed -n '2,/^[^#]/{ /^[^#]/d; s/^# //; s/^#$//; p; }' "$0"
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)  DRY_RUN=true; shift ;;
    --help|-h)  show_help ;;
    *)          error "Unknown option: $1"; exit 1 ;;
  esac
done

# ========================================
# Path setup
# ========================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"

ISSUE_FILE="docs/issues/issue_open.md"
TARGET_BRANCH="ai/workflow_issue"
REMOTE="origin"

# ========================================
# Pre-checks
# ========================================

echo ""
info "== Pre-checks =="

ERRORS=0

# 1. Check issue_open.md exists
if [ ! -f "$ISSUE_FILE" ]; then
  error "Issue file not found: $ISSUE_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 2. Check for template state (unfilled placeholders remain)
if [ -f "$ISSUE_FILE" ]; then
  if grep -qF '{TITLE}' "$ISSUE_FILE" || grep -qF '{NN}' "$ISSUE_FILE" \
     || grep -qF '{condition1}' "$ISSUE_FILE"; then
    error "Issue file appears to be in template state (contains unfilled placeholders): $ISSUE_FILE"
    ERRORS=$((ERRORS + 1))
  fi
fi

# 3. Check file is not empty
if [ -f "$ISSUE_FILE" ] && [ ! -s "$ISSUE_FILE" ]; then
  error "Issue file is empty: $ISSUE_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 4. Check git command exists
if ! command -v git &>/dev/null; then
  error "git command not found"
  ERRORS=$((ERRORS + 1))
fi

# 5. Check origin remote exists
if ! git remote get-url "$REMOTE" &>/dev/null; then
  error "Remote '$REMOTE' not found"
  ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -gt 0 ]; then
  error "Pre-checks failed ($ERRORS error(s)). Aborting."
  exit 1
fi

# Detect issue number (for commit message)
ISSUE_NUM=$(grep -oE 'I[0-9]+-[0-9]+' "$ISSUE_FILE" | head -1 || true)
if [ -z "$ISSUE_NUM" ]; then
  ISSUE_NUM="issue"
fi

# Warn if ai/workflow_issue has extra commits beyond issue_open.md
EXTRA_FILES=""
if git show-ref --verify --quiet "refs/remotes/$REMOTE/main" \
   && git show-ref --verify --quiet "refs/remotes/$REMOTE/$TARGET_BRANCH"; then
  EXTRA_FILES=$(git diff --name-only "refs/remotes/$REMOTE/main"..."refs/remotes/$REMOTE/$TARGET_BRANCH" \
                | grep -v "^$ISSUE_FILE$" || true)
  if [ -n "$EXTRA_FILES" ]; then
    warn "Remote $TARGET_BRANCH has files beyond $ISSUE_FILE that will be discarded by reset:"
    echo "$EXTRA_FILES" | sed 's/^/    /'
    warn "(These files are safe if already on main; otherwise commit them to main first)"
  fi
fi

ok "All pre-checks passed"

# ========================================
# Display execution plan
# ========================================

CURRENT_BRANCH="$(git branch --show-current)"
echo ""
info "== Execution plan =="
echo "  Current branch:  $CURRENT_BRANCH"
echo "  Target branch:   $TARGET_BRANCH (will reset to $REMOTE/main)"
echo "  Issue file:      $ISSUE_FILE"
echo "  Commit message:  workflow: submit $ISSUE_NUM for AI processing"
echo "  Dry-run:         $DRY_RUN"
echo ""

# ========================================
# Step 1: Back up issue_open.md (temp file)
# ========================================

info "Step 1: Backing up $ISSUE_FILE"
TMP_BACKUP=$(mktemp /tmp/submit_issue.XXXXXX)
trap 'rm -f "$TMP_BACKUP"' EXIT

if [ "$DRY_RUN" = true ]; then
  info "(dry-run) cp $ISSUE_FILE -> $TMP_BACKUP"
else
  cp "$ISSUE_FILE" "$TMP_BACKUP"
fi
ok "Step 1 done"

# ========================================
# Step 2: Switch to ai/workflow_issue branch
# ========================================

info "Step 2: Switching to $TARGET_BRANCH"
if [ "$DRY_RUN" = true ]; then
  info "(dry-run) git checkout $TARGET_BRANCH (or create)"
else
  if git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
    git checkout "$TARGET_BRANCH"
  else
    git checkout -b "$TARGET_BRANCH"
  fi
fi
ok "Step 2 done"

# ========================================
# Step 3: Reset to origin/main (ensure clean state)
# ========================================

info "Step 3: Resetting $TARGET_BRANCH to $REMOTE/main"
if [ "$DRY_RUN" = true ]; then
  info "(dry-run) git fetch $REMOTE"
  info "(dry-run) git reset --hard $REMOTE/main"
else
  git fetch "$REMOTE" --quiet
  git reset --hard "$REMOTE/main"
fi
ok "Step 3 done"

# ========================================
# Step 4: Restore issue_open.md from backup
# ========================================

info "Step 4: Restoring $ISSUE_FILE from backup"
if [ "$DRY_RUN" = true ]; then
  info "(dry-run) cp $TMP_BACKUP -> $ISSUE_FILE"
else
  mkdir -p "$(dirname "$ISSUE_FILE")"
  cp "$TMP_BACKUP" "$ISSUE_FILE"
fi
ok "Step 4 done"

# ========================================
# Step 5: Commit and push
# ========================================

info "Step 5: Committing and pushing"
if [ "$DRY_RUN" = true ]; then
  info "(dry-run) git add $ISSUE_FILE"
  info "(dry-run) git commit -m 'workflow: submit $ISSUE_NUM for AI processing'"
  info "(dry-run) git push --force-with-lease $REMOTE $TARGET_BRANCH"
else
  git add "$ISSUE_FILE"
  if git diff --cached --quiet; then
    warn "No changes to commit (issue_open.md already matches $REMOTE/main)"
  else
    git commit -m "workflow: submit $ISSUE_NUM for AI processing"
    git push --force-with-lease "$REMOTE" "$TARGET_BRANCH"
  fi
fi
ok "Step 5 done"

# ========================================
# Completion summary
# ========================================

echo ""
echo "==============="
if [ "$DRY_RUN" = true ]; then
  warn "DRY-RUN complete - no changes were made"
else
  ok "Submit complete"
fi
echo "  Issue:   $ISSUE_NUM"
echo "  Branch:  $TARGET_BRANCH (pushed to $REMOTE)"
echo "  Next:    Start AI session and tell it to handle the issue"
echo "==="
