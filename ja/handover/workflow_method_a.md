# AI ワークフロー — Method A（対話型）

Method A は、AI が対話的なチャットセッションでガイダンスを提供するが、
コードの直接実行やファイルの変更は行わない、デフォルトのワークフローである。

共通ルール（ブランチポリシー、引き継ぎドキュメント、ファイル管理、セッション終了
チェックリスト）は [workflow_common.md](workflow_common.md) に定義されている。

## スコープと優先順位

- 本ファイルは Method A の運用ポリシーである。
- 詳細なセッション手順は [session_protocol_method_a.md](session_protocol_method_a.md) に記載。
- 引き継ぎドキュメントの目次: [README.md](README.md)。

## 必須読み込み順序（セッション開始時）

1. [README.md](README.md)（引き継ぎインデックス）
2. [workflow_common.md](workflow_common.md)（共通ルール）
3. [workflow_method_a.md](workflow_method_a.md)（本ファイル）
4. [handover_memo_latest.md](handover_memo_latest.md)（現在のプロジェクト状態）
5. [session_protocol_method_a.md](session_protocol_method_a.md)（詳細手順）
6. [handover_memo_format.md](handover_memo_format.md)（メモ更新フォーマット）

## デフォルトワークフロー（Method A）

1. 一時ブランチを作成して切り替える: `ai/<YYYY-MM-DD>-<topic>`。
2. AI がファイル内容や正確なコマンドを提供し、ユーザがローカルに変更を適用する。
3. ユーザが結果と変更ファイルを報告する（または明示的に必要な場合にコミットする）。
4. AI がフィードバックをレビューし、反復する。
5. マージ前に、不要な一時的成果物を削除する。
6. `main` へスカッシュマージする。

AI の情報取得には、必要に応じて以下のチャネルを並行して使用する: 添付、プロンプト内
コードブロック、MCP 取得。チャネルの選択はファイルサイズ、リソースの制約、タスクの目的に依存する。

MCP 接続メタデータは [README.md](README.md) の「MCP 参照メタ情報」に管理されている。
詳細（チャネル選択、MCP の標準的な使い方、コミットタイミング、`_ai_logs`、
中断時の対応）は [session_protocol_method_a.md](session_protocol_method_a.md) を参照。

## フォールバック方式

- **Method A2**（ターミナル → ペースト）: 直接出力の確認が必要だが、ファイル
  添付が利用できない場合に使用する。
- **Method A3**（GitHub Web UI からの直接コミット）: ローカルターミナルへのアクセスが利用できない場合にのみ使用する。

## 次回セッションファイルのローテーション（Method A）

`handover/next_session/YYYY-MM-DD-N.md` を作成した後、ユーザは古い日付付き
次回セッションファイルを手動でアーカイブすること：

```bash
./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md
```

`handover/next_session/` には最新の日付付きファイルのみを残し、
古いファイルは `_legacy/handover/next_session/` に移動する。
