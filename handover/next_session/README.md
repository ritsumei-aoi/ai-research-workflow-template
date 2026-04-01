# Next Session Prompt Kit

このディレクトリは、次セッションを開始・終了するためのプロンプト群を管理します。

## 目的

- 次セッション用の指示ファイルを安定して作成する。
- 長いテンプレートを責務ごとに分割し、更新容易性を上げる。

## ファイル構成

- `template.md`
  - 次セッションファイルを作るための最小コントローラ。
- `prompt_pack_start.md`
  - セッション開始時に使うプロンプト群。
- `prompt_pack_finish.md`
  - セッション終了時に使う必須プロンプト群。
- `prompt_pack_review.md`
  - 任意の振り返り・リソース確認プロンプト群。

## 推奨実行順

1. `prompt_pack_start.md`
2. 実装作業
3. `prompt_pack_finish.md`
4. 必要な場合のみ `prompt_pack_review.md`

## 運用ルール

- `template.md` は「参照順・必須入力・出力先命名」だけを保持する。
- 個別プロンプト本文は `prompt_pack_*.md` のみで管理する。
- テンプレート以外の「日付付き next session 指示ファイル」は常に最新1件のみを
  `handover/next_session/` に保持する。
- 旧ファイルは `_legacy/handover/next_session/` に移動する。
- 新規プロンプト追加時は、用途に応じて適切な pack に入れる。
- `log/` のセッション全体記録は `log/README.md` の方針に従う。

### 旧 next session ファイルの移動

- **Method A（手動）**:
  1. 次回用ファイルを作成後、以下を実行する。
     - `./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md`
  2. `git status` で移動結果を確認する。
- **Method B（AIエージェント）**:
  - AI が上記スクリプトを実行し、移動後に `git status` を提示する。
