# AI ワークフロー — 共通ルール

本ファイルは、AI 支援ワークフローの全方式に共通するルールを定義する。

方式固有のルールは [workflow_method_a.md](workflow_method_a.md)（対話型）、
[workflow_method_b.md](workflow_method_b.md)（イシュー駆動エージェント型）、
および [workflow_method_c.md](workflow_method_c.md)（GitHub Agentic ワークフロー、ドラフト）を参照。

イシュー駆動ワークフローは Method B に統合されている。Method A または C を使用する場合も、
イシュー処理は [workflow_method_b.md](workflow_method_b.md) に記述された同じ構造（Phase 1-4）に従うが、
実行方法は方式によって異なる。

方式の比較と選択ガイド: [workflow_methods_comparison.md](workflow_methods_comparison.md)。

## 方式一覧

| 方式 | 実行主体 | AI のファイルアクセス | 主要ドキュメント |
|---|---|---|---|
| **Method A** | ユーザ（ローカルターミナル） | 読み取り専用（添付 / MCP / プロンプト） | [workflow_method_a.md](workflow_method_a.md) |
| **Method B** | AI エージェント（直接実行） | 完全（読み書き実行） | [workflow_method_b.md](workflow_method_b.md) |
| **Method C** | GitHub Agentic ワークフロー | 完全（GitHub 経由） | [workflow_method_c.md](workflow_method_c.md)（ドラフト） |

## 基本原則

- まず計画し、次に成果物を作成する。
- 要件が不明確な場合は質問する。
- 出力は簡潔で検証可能なものにする。
- 永続化スキーマは安定させる: `schema_version` は必須。破壊的変更にはバージョンの引き上げが必要。
- 常に AI 委任境界（[ai_trust_policy.md](ai_trust_policy.md)）に従う。

## ブランチポリシー

1. Method B: 固定の `ai/workflow_issue` ブランチ。
2. Method A: `ai/<YYYY-MM-DD>-<topic>` 日付トピックブランチ。
3. Method C: `agentic/<issue>-<topic>` イシューベースブランチ。
4. `main` へのマージは `git merge --squash` で行う。
5. マージ前に不要な一時ファイルを削除する。

## 引き継ぎドキュメントポリシー

- `handover_memo_latest.md` は最新セッションのみを保持する。前回のセッションは
  `handover_memo_archived.md` に移動する。
- メモの正確な構造とテンプレートは [handover_memo_format.md](handover_memo_format.md) に定義されている。

## ファイル・リンク管理

- リポジトリ内の参照には相対リンクを使用する。
- `handover/*.md` ファイルの追加・名前変更・用途変更を行う場合は、同じ変更で [README.md](README.md)
  も更新する。

## セッション開始チェックリスト

各セッションの開始時に、エージェントは以下を実施すること：

- [ ] 引き継ぎドキュメントを所定の順序で読み込む（[workflow_method_b.md](workflow_method_b.md) を参照）
- [ ] 読み込み確認を出力する（Method B の必須プロトコル）
- [ ] 現在のブランチを確認するか、適切なブランチを作成する
- [ ] `git status` と `git log --oneline -5` を確認する
- [ ] `docs/issues/issue_open.md` で未対応イシューを確認する
- [ ] まだ述べられていない場合、セッション目標をユーザと確認する

## セッション終了チェックリスト

- [ ] テスト通過（`pytest tests/ -v`）
- [ ] `git status` を確認済み
- [ ] ブランチを push 済み（該当する場合）
- [ ] `handover_memo_latest.md` を更新済み
- [ ] 一時ファイルを削除済み
- [ ] スカッシュマージの準備または完了
