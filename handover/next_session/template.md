# Next Session Instructions (Controller Template)

このファイルは「次セッション用指示ファイル」を作るための最小コントローラです。

## Purpose

目的は次の1点です。
- 次セッションのために指定するプロンプトを、安定した順序で作成する。

実際のプロンプト本文は以下の分割ファイルを参照します。
- `prompt_pack_start.md`
- `prompt_pack_finish.md`
- `prompt_pack_review.md`（任意）

## Required Inputs

次セッションファイルを作成する前に、以下を用意します。
- `handover/README.md`（handover index）
- `handover/workflow_common.md`
- `handover/workflow_method_b.md`（AIエージェント運用時）または
	`handover/workflow_method_a.md`（対話運用時）
- `handover/session_protocol_method_a.md`（Method A 詳細）
- `handover/handover_memo_format.md`
- `handover/handover_memo_latest.md`
- `log/README.md`
- <!-- CUSTOMIZE: Add project-specific reference files here -->

## Build Procedure

1. `prompt_pack_start.md` から開始プロンプトを取得する。
2. 実装作業を行う。
3. `prompt_pack_finish.md` から終了プロンプトを取得する。
4. 必要な場合のみ `prompt_pack_review.md` を使う。
5. 次セッションファイルを `handover/next_session/YYYY-MM-DD-N.md` として出力する。
6. 旧 `handover/next_session/YYYY-MM-DD-N.md` を
	`_legacy/handover/next_session/` へ移動する。

## Output Naming

- 形式: `handover/next_session/YYYY-MM-DD-N.md`
- `YYYY-MM-DD`: セッション終了日
- `N`: 同日内の連番（1, 2, 3, ...）

## Replacement Checklist

作成時に次を必ず具体化します。
- `<session-goals>`
- `<topic>`
- 日付と連番
- 参照ログファイル名

## Notes

- `handover/` は repo-specific handover 用です。
- `log/` は session-wide/project-wide 記録用です。
- コードブロック入れ子が必要な場合は、外側4バッククォート・内側3バッククォートを使用します。

## Metadata

- Template Version: 2.0
- Created: 2026-03-08
- Last Updated: 2026-03-08
