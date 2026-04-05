# handover 目次

このディレクトリは、AI セッション運用・実装の引き継ぎ・理論仕様メモをまとめるための資料置き場です。

- ファイルのリンクはこのファイルがある `handover` から見ての相対パスになります。

## MCP 参照メタ情報

このREADMEのリンク解決は `base_path` を基準にします。

<!-- CUSTOMIZE: Update repository metadata -->
- owner: `your-github-username`
- repo: `your-repo-name`
- base_path: `handover/`
- default_ref: `main`

## 1. まず読む（セッション運用）

推奨読了順（全方式共通）:
1. この `README.md`
2. `workflow_common.md`（全方式共通ルール）
3. `workflow_method_b.md`（AIエージェント使用時）/ `workflow_method_a.md`（対話使用時）
4. `ai_trust_policy.md`（AI 委任境界）
5. `handover_memo_latest.md`
6. `docs/issues/issue_open.md`（イシュー確認）

- [共通ワークフロー ルール](workflow_common.md)
  - 全方式共通: Method 比較表、ブランチ規則、引き継ぎポリシー、セッション終了チェックリスト。
- [AI ワークフロー — Method B（イシュー駆動エージェント型）](workflow_method_b.md)
  - Copilot Chat, Gemini CLI 等、AI が直接ファイル編集・コマンド実行できる環境向け。イシュー駆動ワークフローを内包。
- [AI ワークフロー — Method C（GitHub Agentic 型）](workflow_method_c.md) **[Draft]**
  - GitHub Issue/PR + Agentic Workflow による自動化。ルーチン作業向け。
- [AI 委任境界ポリシー](ai_trust_policy.md)
  - AI に委任可能なタスクと委任不可なタスクの明示的定義。
- [Method 比較ガイド](workflow_methods_comparison.md)
  - Method A/B/C の比較表、選択フローチャート、使い分けガイド。
- [AI ワークフロー — Method A（対話型）](workflow_method_a.md)
  - ブラウザチャット等、AI が直接実行できない環境向けのポリシー。
- [Handover Memo Format](handover_memo_format.md)
  - `handover_memo_latest.md` / `handover_memo_archived.md` のテンプレート定義。
- [Handover Memo (Latest)](handover_memo_latest.md)
  - 最新セッションの進捗、次回への引き継ぎ、直近の注意点。
- [Handover Memo (Archived)](handover_memo_archived.md)
  - 過去セッションの履歴（時系列、追記型）。

## 2. 実装仕様・設計資料

<!-- CUSTOMIZE: Add project-specific implementation documents here. Example:
- [コード構造](code_structure.md)
  - 現行モジュール構成、パイプライン、処理フロー。
- [記法と用語の定義](notation.md)
  - 本リポジトリで使う記法・用語の統一ルール。
-->

## 3. 導出・理論資料

> 理論関連ファイルは `docs/theory/` に集約。[docs/theory/README.md](../docs/theory/README.md) も参照。
> イシュー記録は `docs/issues/` に集約。[docs/issues/README.md](../docs/issues/README.md) も参照。

<!-- CUSTOMIZE: Add project-specific theory documents here. -->

## 4. 参照・調査資料

<!-- CUSTOMIZE: Add project-specific references here. -->

## 5. レガシー資料

`_legacy/handover/` に移動済み（参照のみ）。

<!-- CUSTOMIZE: Add legacy file references as your project evolves -->

## 運用メモ

- `handover/` に Markdown ファイルを新規追加・改名・用途変更した場合は、この目次を同時に更新してください。
- リポジトリ内リンクは相対パスで記述してください。
