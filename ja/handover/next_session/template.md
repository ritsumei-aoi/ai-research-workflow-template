# 次回セッション指示ファイル（コントローラテンプレート）

このファイルは「次セッション用指示ファイル」を作るための最小コントローラです。

## 目的

目的は次の1点です。
- 次セッションのために指定するプロンプトを、安定した順序で作成する。

実際のプロンプト本文は以下の分割ファイルを参照します。
- `prompt_pack_start.md`
- `prompt_pack_finish.md`
- `prompt_pack_issue.md`（任意）

## 必須入力

次セッションファイルを作成する前に、以下を用意します。
- `handover/README.md`（引き継ぎインデックス）
- `handover/workflow_common.md`
- `handover/workflow_method_b.md`（AIエージェント運用時）または
	`handover/workflow_method_a.md`（対話運用時）
- `handover/session_protocol_method_a.md`（Method A 詳細）
- `handover/handover_memo_format.md`
- `handover/handover_memo_latest.md`
- `log/README.md`
- <!-- CUSTOMIZE: プロジェクト固有の参照ファイルをここに追加 -->

## 作成手順

1. `prompt_pack_start.md` から開始プロンプトを取得する。
2. 実装作業を行う。
3. `prompt_pack_finish.md` から終了プロンプトを取得する。
4. 必要な場合のみ `prompt_pack_issue.md` を使う。
5. 次セッションファイルを `handover/next_session/YYYY-MM-DD-N.md` として出力する。
6. 旧 `handover/next_session/YYYY-MM-DD-N.md` を
	`_legacy/handover/next_session/` へ移動する。

## 出力ファイル命名規則

- 形式: `handover/next_session/YYYY-MM-DD-N.md`
- `YYYY-MM-DD`: セッション終了日
- `N`: 同日内の連番（1, 2, 3, ...）

## 置換チェックリスト

作成時に次を必ず具体化します。
- `<session-goals>`
- `<topic>`
- 日付と連番
- 参照ログファイル名

## 備考

- `handover/` はリポジトリ固有の引き継ぎ用です。
- `log/` はセッション全体/プロジェクト全体の記録用です。
- コードブロック入れ子が必要な場合は、外側4バッククォート・内側3バッククォートを使用します。

## メタデータ

- テンプレートバージョン: 2.0
- 作成日: 2026-03-08
- 最終更新: 2026-03-08
