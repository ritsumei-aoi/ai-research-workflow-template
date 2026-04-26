#!/usr/bin/env bash
# submit-issue.sh — Phase 1 完了処理: issue_open.md を ai/workflow_issue ブランチへ送信
#
# 概要:
#   人間が docs/issues/issue_open.md を記述した後、AI エージェントが
#   処理できる状態にするために ai/workflow_issue ブランチへ送信する。
#   ai/workflow_issue を origin/main ベースにリセットした上で
#   issue_open.md のみをコミットして push する（クリーンな提出）。
#
# 使い方:
#   ./handover/scripts/submit-issue.sh [OPTIONS]
#
# オプション:
#   --dry-run    書き込み・git操作を行わず、計画のみ表示
#   --help       ヘルプ表示
#
# 例:
#   # 通常実行
#   ./handover/scripts/submit-issue.sh
#
#   # dry-run で計画確認
#   ./handover/scripts/submit-issue.sh --dry-run
#
# 前提条件:
#   - docs/issues/issue_open.md が記述済み（テンプレート状態でないこと）
#   - origin（リモート）へのプッシュ権限があること
#   - カレントディレクトリがリポジトリルート（任意のブランチで動作可）
#
# 注意:
#   - ai/workflow_issue ブランチは origin/main に強制リセットされる
#   - issue_open.md 以外のブランチ固有の変更は失われる（バックアップ推奨）
#   - AI が issue_open.md 以外のファイル（例: memo/*.md）も参照する場合は
#     main にコミットしてから実行するか、AI セッション開始後に手動で追加すること

set -euo pipefail

# ========================================
# ユーティリティ関数
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
# 引数パース
# ========================================

DRY_RUN=false

show_help() {
  # ファイルの先頭コメント（# で始まる行）を表示（# プレフィックスを除去）
  sed -n '/^#!/d; 2,/^[^#]/{ /^[^#]/d; s/^# //; s/^#$//; p; }' "$0"
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
# パス設定
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
info "=== Pre-checks ==="

ERRORS=0

# 1. issue_open.md の存在確認
if [ ! -f "$ISSUE_FILE" ]; then
  error "Issue file not found: $ISSUE_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 2. テンプレート状態の確認（未記入のプレースホルダが残っている場合）
if [ -f "$ISSUE_FILE" ]; then
  if grep -qF '{タイトル}' "$ISSUE_FILE" || grep -qF '{NN}' "$ISSUE_FILE" \
     || grep -qF '{条件1}' "$ISSUE_FILE"; then
    error "Issue file appears to be in template state (contains unfilled placeholders): $ISSUE_FILE"
    ERRORS=$((ERRORS + 1))
  fi
fi

# 3. ファイルが空でないことの確認
if [ -f "$ISSUE_FILE" ] && [ ! -s "$ISSUE_FILE" ]; then
  error "Issue file is empty: $ISSUE_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 4. git コマンドの存在確認
if ! command -v git &>/dev/null; then
  error "git command not found"
  ERRORS=$((ERRORS + 1))
fi

# 5. origin リモートの存在確認
if ! git remote get-url "$REMOTE" &>/dev/null; then
  error "Remote '$REMOTE' not found"
  ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -gt 0 ]; then
  error "Pre-checks failed ($ERRORS error(s)). Aborting."
  exit 1
fi

# イシュー番号を検出（コミットメッセージ用）
ISSUE_NUM=$(grep -oE 'I[0-9]+-[0-9]+' "$ISSUE_FILE" | head -1 || true)
if [ -z "$ISSUE_NUM" ]; then
  ISSUE_NUM="issue"
fi

# ai/workflow_issue に main 以外のコミットがある場合は警告
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
# 実行計画の表示
# ========================================

CURRENT_BRANCH="$(git branch --show-current)"
echo ""
info "=== Execution plan ==="
echo "  Current branch:  $CURRENT_BRANCH"
echo "  Target branch:   $TARGET_BRANCH (will reset to $REMOTE/main)"
echo "  Issue file:      $ISSUE_FILE"
echo "  Commit message:  workflow: submit $ISSUE_NUM for AI processing"
echo "  Dry-run:         $DRY_RUN"
echo ""

# ========================================
# Step 1: issue_open.md のバックアップ（/tmp に一時退避）
# ========================================

info "Step 1: Backing up $ISSUE_FILE"
TMP_BACKUP=$(mktemp /tmp/submit_issue.XXXXXX)
trap 'rm -f "$TMP_BACKUP"' EXIT

if [ "$DRY_RUN" = true ]; then
  info "(dry-run) cp $ISSUE_FILE → $TMP_BACKUP"
else
  cp "$ISSUE_FILE" "$TMP_BACKUP"
fi
ok "Step 1 done"

# ========================================
# Step 2: ai/workflow_issue ブランチへ切り替え
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
# Step 3: origin/main にリセット（クリーンな状態を確保）
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
# Step 4: issue_open.md を復元
# ========================================

info "Step 4: Restoring $ISSUE_FILE from backup"
if [ "$DRY_RUN" = true ]; then
  info "(dry-run) cp $TMP_BACKUP → $ISSUE_FILE"
else
  mkdir -p "$(dirname "$ISSUE_FILE")"
  cp "$TMP_BACKUP" "$ISSUE_FILE"
fi
ok "Step 4 done"

# ========================================
# Step 5: コミットとプッシュ
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
# 完了サマリー
# ========================================

echo ""
echo "==========================================="
if [ "$DRY_RUN" = true ]; then
  warn "DRY-RUN complete — no changes were made"
else
  ok "Submit complete"
fi
echo "  Issue:   $ISSUE_NUM"
echo "  Branch:  $TARGET_BRANCH (pushed to $REMOTE)"
echo "  Next:    Start AI session and tell it to handle the issue"
echo "==========================================="
