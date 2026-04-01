# handover 目次

このディレクトリは、AI セッション運用・実装の引き継ぎ・理論仕様メモをまとめるための資料置き場です。

- ファイルのリンクはこのファイルがある `handover`から見ての相対パスになります．

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
3. `workflow_review.md`（レビュー駆動ワークフロー — `review_open.md` があれば最優先）
4. `workflow_method_b.md`（AIエージェント使用時）/ `workflow_method_a.md`（対話使用時）/ `workflow_method_c.md`（GitHub Agentic 使用時）
5. `handover_memo_latest.md`
6. 詳細手順が必要な場合: `session_protocol_method_a.md`（Method A 使用時）
7. `handover_memo_format.md`

- [共通ワークフロー ルール](workflow_common.md)
  - 全方式共通: Method 比較表、ブランチ規則、引き継ぎポリシー、セッション終了チェックリスト。
- [レビュー駆動ワークフロー](workflow_review.md)
  - Method A/B/C 共通: `docs/reviews/` のレビュー指摘への優先対応手順。`review_open.md` の有無で判定。
- [AI ワークフロー — Method B（AIエージェント型）](workflow_method_b.md)
  - Copilot Chat, Gemini CLI 等、AI が直接ファイル編集・コマンド実行できる環境向けのポリシー。
- [AI ワークフロー — Method C（GitHub Agentic 型）](workflow_method_c.md) **[Draft]**
  - GitHub Issue/PR + Agentic Workflow による自動化。ルーチン作業向け。
- [Method 比較ガイド](workflow_methods_comparison.md)
  - Method A/B/C の比較表、選択フローチャート、使い分けガイド。
- [AI ワークフロー — Method A（対話型）](workflow_method_a.md)
  - ブラウザチャット等、AI が直接実行できない環境向けのポリシー。
- [Session Protocol — Method A (Detailed)](session_protocol_method_a.md)
  - Method A の詳細手順、_ai_logs、中断時対応、セッション開始/終了手順。
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
> レビュー記録は `docs/reviews/` に集約。[docs/reviews/README.md](../docs/reviews/README.md) も参照。

<!-- CUSTOMIZE: Add project-specific theory documents here. Example:
- [証明文書](../docs/theory/proofs/)
  - 形式的な証明の記録。
- [解析レポート](../docs/theory/analysis/)
  - 計算的解析の結果。
-->

## 4. 参照・調査資料

<!-- CUSTOMIZE: Add project-specific references here. Example:
- [参考文献・関連資料](references.md)
  - 論文・関連リンク。
-->

## 5. 次回セッション用

- [next_session/](next_session/)
  - 次回セッション用プロンプトキットと個別指示ファイル置き場。
- [next_session/README.md](next_session/README.md)
  - 分割された prompt pack の使い方と推奨順序。
- [next_session/template.md](next_session/template.md)
  - 次セッション指示ファイルを作るための最小コントローラ。
- [next_session/prompt_pack_start.md](next_session/prompt_pack_start.md)
  - セッション開始用プロンプト群。
- [next_session/prompt_pack_finish.md](next_session/prompt_pack_finish.md)
  - セッション終了用プロンプト群（必須）。
- [next_session/prompt_pack_review.md](next_session/prompt_pack_review.md)
  - 振り返り・リソース確認用プロンプト群（任意）。

## 6. レガシー資料

`_legacy/handover/` に移動済み（参照のみ）。

<!-- CUSTOMIZE: Add legacy file references as your project evolves -->

## 運用メモ

- `handover/` に Markdown ファイルを新規追加・改名・用途変更した場合は、この目次を同時に更新してください。
- リポジトリ内リンクは相対パスで記述してください。
