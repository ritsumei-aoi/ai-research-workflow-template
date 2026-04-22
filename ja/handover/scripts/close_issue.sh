#!/usr/bin/env bash
# close_issue.sh — Phase 4 完了処理の自動化スクリプト（単一イシュー版）
#
# 概要:
#   1つのイシューに対して Phase 4 完了処理を実行する。
#   複数イシューがある場合、呼び出し側（AIエージェント）が事前に
#   issue_open.md を分割し、個別ファイルとして渡す。
#
# 使い方:
#   ./handover/scripts/close_issue.sh [OPTIONS] <YYMMDD> <NN> <issue_label> <next_issue_number>
#
# オプション:
#   --issue-file <path>      アーカイブ対象のイシュー内容ファイル（省略時: issue_open.md）
#   --remaining-file <path>  処理後に issue_open.md に配置する内容（省略時: テンプレート）
#   --dry-run                書き込み・git操作を一切行わず、計画のみ表示
#   --skip-git               git操作をスキップ（アーカイブのみ実行）
#   --skip-taio-check        「### 対応」セクションの存在チェックをスキップ
#   --help                   ヘルプ表示
#
# 例:
#   # 通常（単一イシュー、テンプレートリセット）
#   ./handover/scripts/close_issue.sh 260413 13 "I13: Phase4スクリプト修正" 14
#
#   # 分割ファイル指定 + 残余ファイル指定（複数イシュー時）
#   ./handover/scripts/close_issue.sh \
#     --issue-file /tmp/issue_i12.md \
#     --remaining-file /tmp/issue_i13.md \
#     260413 12 "I12: mathqform試験運用" 14
#
#   # dry-run で計画確認
#   ./handover/scripts/close_issue.sh --dry-run 260413 13 "I13: スクリプト修正" 14
#
# 前提条件:
#   - イシューの完了条件は [x] 済み、### 対応 セクション追記済み
#   - handover_memo_latest.md は更新済み（またはスクリプト実行後に更新予定）
#   - カレントディレクトリがリポジトリルート
#   - ai/workflow_issue ブランチで作業中
#
# 設計方針:
#   - 1回の実行で1イシューのみ処理（複数対応は呼び出し側の責任）
#   - git add は対象ファイルのみ（-A は使わない）
#   - --dry-run 時は一切のファイル操作・git操作を行わない
#   - エラー時は途中で停止し、完了済みの操作はロールバックしない

set -euo pipefail

# ========================================
# ユーティリティ関数
# ========================================

# カラー出力（ターミナル対応時のみ）
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

# dry-run 対応のファイル操作ラッパー
do_cp() {
  if [ "$DRY_RUN" = true ]; then
    info "(dry-run) cp $1 → $2"
  else
    cp "$1" "$2"
  fi
}

do_write() {
  # $1: 出力先, stdin: 内容
  if [ "$DRY_RUN" = true ]; then
    info "(dry-run) write → $1"
    cat > /dev/null  # stdin を消費
  else
    cat > "$1"
  fi
}

do_git() {
  if [ "$DRY_RUN" = true ]; then
    info "(dry-run) git $*"
  elif [ "$SKIP_GIT" = true ]; then
    info "(skip-git) git $*"
  else
    git "$@"
  fi
}

# ========================================
# 引数パース
# ========================================

DRY_RUN=false
SKIP_GIT=false
SKIP_TAIO_CHECK=false
ISSUE_FILE=""
REMAINING_FILE=""

show_help() {
  sed -n '2,/^$/{ s/^# //; s/^#$//; p; }' "$0"
  exit 0
}

# オプション引数をパース
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)       DRY_RUN=true; shift ;;
    --skip-git)      SKIP_GIT=true; shift ;;
    --skip-taio-check) SKIP_TAIO_CHECK=true; shift ;;
    --issue-file)    ISSUE_FILE="$2"; shift 2 ;;
    --remaining-file) REMAINING_FILE="$2"; shift 2 ;;
    --help|-h)       show_help ;;
    -*)              error "Unknown option: $1"; exit 1 ;;
    *)               break ;;  # 位置引数の開始
  esac
done

# 位置引数のチェック
if [ $# -lt 4 ]; then
  error "Usage: $0 [OPTIONS] <YYMMDD> <NN> <issue_label> <next_issue_number>"
  echo ""
  echo "  YYMMDD:            日付 (例: 260413)"
  echo "  NN:                同日連番 (例: 13)"
  echo "  issue_label:       コミットメッセージ用ラベル (例: 'I13: Phase4スクリプト修正')"
  echo "  next_issue_number: 次のイシュー番号 (例: 14)"
  echo ""
  echo "Options: --issue-file <path>  --remaining-file <path>  --dry-run  --skip-git  --help"
  exit 1
fi

YYMMDD="$1"
NN="$2"
ISSUE_LABEL="$3"
NEXT_NN="$4"

# ========================================
# パス設定
# ========================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"

ISSUE_OPEN="docs/issues/issue_open.md"
DONE_DIR="docs/issues/done"
DONE_FILE="${DONE_DIR}/issue_${YYMMDD}_${NN}.md"
TEMPLATE="docs/issues/template_issue_open.md"
HISTORY="docs/issues/issue_history.md"
HANDOVER_MEMO="handover/handover_memo_latest.md"

# --issue-file 省略時は issue_open.md を使用
if [ -z "$ISSUE_FILE" ]; then
  ISSUE_FILE="$ISSUE_OPEN"
fi

# ========================================
# Pre-checks（書き込み前にすべて検証）
# ========================================

echo ""
info "=== Pre-checks ==="

ERRORS=0

# 1. ブランチ確認
CURRENT_BRANCH="$(git branch --show-current)"
if [ "$CURRENT_BRANCH" != "ai/workflow_issue" ]; then
  error "Current branch is '$CURRENT_BRANCH', expected 'ai/workflow_issue'"
  ERRORS=$((ERRORS + 1))
fi

# 2. ワーキングツリーのクリーン確認（--issue-file 使用時のみ厳格）
if [ "$ISSUE_FILE" != "$ISSUE_OPEN" ]; then
  DIRTY="$(git status --porcelain)"
  if [ -n "$DIRTY" ]; then
    warn "Working tree has uncommitted changes:"
    echo "$DIRTY" | head -10
    # 警告のみ（エラーにはしない — AIエージェントが意図的に変更している場合がある）
  fi
fi

# 3. アーカイブ先の重複チェック
if [ -f "$DONE_FILE" ]; then
  error "Archive target already exists: $DONE_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 4. イシューファイルの存在チェック
if [ ! -f "$ISSUE_FILE" ]; then
  error "Issue file not found: $ISSUE_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 5. テンプレートの存在チェック（remaining-file がない場合のみ）
if [ -z "$REMAINING_FILE" ] && [ ! -f "$TEMPLATE" ]; then
  error "Template not found: $TEMPLATE (needed for issue_open.md reset)"
  ERRORS=$((ERRORS + 1))
fi

# 6. remaining-file の存在チェック（指定されている場合）
if [ -n "$REMAINING_FILE" ] && [ ! -f "$REMAINING_FILE" ]; then
  error "Remaining file not found: $REMAINING_FILE"
  ERRORS=$((ERRORS + 1))
fi

# 7. done/ ディレクトリの存在チェック
if [ ! -d "$DONE_DIR" ]; then
  error "Done directory not found: $DONE_DIR"
  ERRORS=$((ERRORS + 1))
fi

# 8. 「### 対応」セクションの存在チェック（R15）
if [ "$SKIP_TAIO_CHECK" = false ] && [ -f "$ISSUE_FILE" ]; then
  if ! grep -q '### 対応' "$ISSUE_FILE"; then
    error "Issue file is missing '### 対応' section: $ISSUE_FILE (use --skip-taio-check to override)"
    ERRORS=$((ERRORS + 1))
  fi
fi

# 9. 完了条件チェックボックスの [x] 確認
if [ -f "$ISSUE_FILE" ]; then
  UNCHECKED=$(grep -c '\- \[ \]' "$ISSUE_FILE" 2>/dev/null || true)
  if [ "$UNCHECKED" -gt 0 ]; then
    error "Issue file has $UNCHECKED unchecked checkbox(es) ('- [ ]'): $ISSUE_FILE"
    ERRORS=$((ERRORS + 1))
  fi
fi

if [ "$ERRORS" -gt 0 ]; then
  error "Pre-checks failed ($ERRORS error(s)). Aborting."
  exit 1
fi

ok "All pre-checks passed"

# ========================================
# 実行計画の表示
# ========================================

echo ""
info "=== Execution plan ==="
echo "  Source:       $ISSUE_FILE"
echo "  Archive to:  $DONE_FILE"
if [ -n "$REMAINING_FILE" ]; then
  echo "  Reset from:  $REMAINING_FILE"
else
  echo "  Reset from:  $TEMPLATE (next: I${NEXT_NN})"
fi
echo "  Commit msg:  $ISSUE_LABEL"
echo "  Dry-run:     $DRY_RUN"
echo "  Skip-git:    $SKIP_GIT"
echo ""

# ========================================
# Step 1: アーカイブ
# ========================================

info "Step 1: Archiving → $DONE_FILE"
do_cp "$ISSUE_FILE" "$DONE_FILE"
ok "Step 1 done"

# ========================================
# Step 2: issue_open.md リセット
# ========================================

if [ -n "$REMAINING_FILE" ]; then
  # 残余ファイルが指定されている場合はその内容で置換
  info "Step 2: Replacing $ISSUE_OPEN with $REMAINING_FILE"
  do_cp "$REMAINING_FILE" "$ISSUE_OPEN"
else
  # テンプレートからリセット
  info "Step 2: Resetting $ISSUE_OPEN from template (next: I${NEXT_NN})"
  if [ "$DRY_RUN" = true ]; then
    info "(dry-run) sed 's/{NN}/${NEXT_NN}/g' $TEMPLATE > $ISSUE_OPEN"
  else
    sed "s/{NN}/${NEXT_NN}/g" "$TEMPLATE" > "$ISSUE_OPEN"
  fi
fi
ok "Step 2 done"

# ========================================
# Step 3: ステージング（特定ファイルのみ）
# ========================================

info "Step 3: Staging specific files"
# 必ずステージするファイル
STAGE_FILES=("$DONE_FILE" "$ISSUE_OPEN")

# issue_history.md が変更されていればステージ
if git diff --name-only -- "$HISTORY" | grep -q .; then
  STAGE_FILES+=("$HISTORY")
fi
if git diff --name-only --cached -- "$HISTORY" | grep -q .; then
  : # already staged
fi

# handover_memo_latest.md が変更されていればステージ
if git diff --name-only -- "$HANDOVER_MEMO" | grep -q .; then
  STAGE_FILES+=("$HANDOVER_MEMO")
fi

# close_issue.sh 自体が変更されていればステージ
SCRIPT_REL="handover/scripts/close_issue.sh"
if git diff --name-only -- "$SCRIPT_REL" | grep -q .; then
  STAGE_FILES+=("$SCRIPT_REL")
fi

for f in "${STAGE_FILES[@]}"; do
  do_git add "$f"
done
ok "Step 3 done (staged ${#STAGE_FILES[@]} file(s): ${STAGE_FILES[*]})"

# ========================================
# Step 4: コミット
# ========================================

COMMIT_MSG="${ISSUE_LABEL}

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"

info "Step 4: Committing"
do_git commit -m "$COMMIT_MSG"
ok "Step 4 done"

# ========================================
# Step 5: プッシュ
# ========================================

info "Step 5: Pushing to origin ai/workflow_issue"
do_git push origin ai/workflow_issue
ok "Step 5 done"

# ========================================
# Step 6: Squash merge to main
# ========================================

info "Step 6: Squash merge to main"
do_git checkout main
do_git pull origin main
if [ "$DRY_RUN" = false ] && [ "$SKIP_GIT" = false ]; then
  git merge --squash ai/workflow_issue --no-edit
  git commit -m "${ISSUE_LABEL} (squash)

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
  git push origin main
else
  do_git merge --squash ai/workflow_issue --no-edit
  do_git commit -m "${ISSUE_LABEL} (squash)"
  do_git push origin main
fi
ok "Step 6 done"

# ========================================
# Step 7: ブランチ同期
# ========================================

info "Step 7: Syncing ai/workflow_issue with main"
do_git checkout ai/workflow_issue
if [ "$DRY_RUN" = false ] && [ "$SKIP_GIT" = false ]; then
  git reset --hard main
  git push --force-with-lease origin ai/workflow_issue
else
  do_git reset --hard main
  do_git push --force-with-lease origin ai/workflow_issue
fi
ok "Step 7 done"

# ========================================
# 完了サマリー
# ========================================

echo ""
echo "==========================================="
if [ "$DRY_RUN" = true ]; then
  warn "DRY-RUN complete — no changes were made"
else
  ok "Phase 4 complete"
fi
echo "  Archived:  $DONE_FILE"
echo "  Next issue: I${NEXT_NN}-1"
echo "  Branch:    ai/workflow_issue (synced with main)"
echo "==========================================="
