# handover 目次

このディレクトリは、AI セッション運用・実装の引き継ぎ・理論仕様メモをまとめるための資料置き場です。

- ファイルのリンクはこのファイルがある `handover`から見ての相対パスになります．

## MCP 参照メタ情報

このREADMEのリンク解決は `base_path` を基準にします。

- owner: `ritsumei-aoi`
- repo: `oscillator-lie-superalgebras`
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

- [コード構造（現行 v5.0）](code_structure.md)
  - 現行モジュール構成、Schema 1/2/3 パイプライン、triviality 判定フロー。
- [コード構造（v4.1 スナップショット）](../_legacy/handover/code_structure_v41.md)
  - 旧スキーマ期の構成記録（参照用）。
- [記法と用語の定義](notation.md)
  - 本リポジトリで使う記法・用語の統一ルール。
- [Theory vs Implementation](theory_vs_implementation.md)
  - 理論と実装の差分、実装上の注意点。`a_0` 規約・sqrt(2) 係数の方針（§7）を含む。

### JSON スキーマ仕様 (Schema v5.0)

- [JSON Schema Specification](../docs/json_schema_specification.md)
  - Schema 1（代数構造）・Schema 2（Gamma 構造）の完全仕様。
- [JSON Schema: Evaluated Structure (Schema 3)](../docs/json_schema_evaluated_structure.md)
  - Schema 3（gh 代入済み構造定数）の仕様。ファイル命名規則（`m`/`p`/`r2` エンコード）を含む。
- [JSON Schema: Coboundary Structure (Schema 4)](../docs/json_schema_coboundary_structure.md)
  - Schema 4（f 写像由来の余境界構造）の仕様。`data/coboundary_structures/` に保存。

## 3. 導出・理論資料

> 理論関連ファイルは `docs/theory/` に集約。[docs/theory/README.md](../docs/theory/README.md) も参照。
> レビュー記録は `docs/reviews/` に集約。[docs/reviews/README.md](../docs/reviews/README.md) も参照。

- [B_generators.py 導出ノート](../docs/theory/derivations/B_generators_derivation.md)
  - B(m,n) 実装に関わる数学的導出の正式記録。
- [代数的証明の数学的基礎](algebraic_proof_basis.md)
  - 体拡大定理（rank 不変性）の証明、triviality 判定基準 `rank([A|L]) = rank(A) + rank(L)` ⟺ `Im(A) ∩ Im(L) = {0}` の導出と解説。
- [標準順序・対称式と論文記法の対応（B(0,1)）](../docs/theory/derivations/normal_order_symmetric.md)
  - osp(1|2) における PBW 標準順序（Frappat 実装）と論文（Bakalov-Sullivan arXiv:1612.09400 §4）の対称式基底の変換表。`gh=[[0,-1]]` が論文記法に対応することを確認。**論文との係数照合・triviality の f 構成時に必ず参照。**
- [論文 §4 草稿: 振動子 Lie 超代数の非斉次拡張と triviality](../docs/theory/draft_sec4_oscillator_triviality.md)
  - 論文 Section 4 に対応する日本語草稿。余境界作用素 δ の定義、B(0,1) の任意 Gram 行列に対する triviality の証明と陽な f 構成、論文 [BS17] との照合を含む。
- [一般 B(m,n) の triviality 証明方針](../docs/theory/proof_strategy_general_Bmn.md)
  - B(0,1) 以外の B(m,n) で「gh=0 のみ trivial」を一般に示すための方針・予備考察。ker(δ) 解析、帰納法、重み分解、コホモロジー的アプローチの 5 方針を記載。
- [Phase 1 解析結果: ker(δ) の重み構造](../docs/theory/phase1_ker_delta_analysis.md)
  - B(0,n) における ker(δ) の Cartan 重み分解の計算結果。各 gh パラメータが唯一の重みセクターに存在し、各セクターで ker(δ)=1 であることを確認。B(0,1) の全 trivial 性と B(0,n≥2) の非 trivial 性の重み分解による説明。
- [Phase 2 解析結果: 左零空間 certificate](../docs/theory/phase2_left_nullspace_analysis.md)
  - B(0,n≥2) の非自明性に対する有理数 certificate の構成。3-4 項の疎な certificate で c^T L ∈ {1,2,4} を確認。3つの certificate Family (対角型/差分型/交差項型) を同定。n=2,3,4 で検証。
- [Phase 3 解析結果: 代数的証明](../docs/theory/phase3_algebraic_proof.md)
  - certificate の c^T A = 0 と c^T L ≠ 0 を δ 展開と γ 構造定数から代数的に検証。各 Family の消去メカニズムを表形式で提示。n=2,3,4 の全 18 certificate で検証完了。
- [n 不変性証明](../docs/theory/proof_n_invariance.md)
  - Family I/II の j-th スロット不変性定理（S_j 内ブラケットの n 非依存性）。Family III の一般 n 公式と n=2 特殊ケース。n=2..5 全 28 certificate 検証。
- [dim(C¹_μ) = 6n−2 証明](../docs/theory/proof_dim_formula.md)
  - 8 分類ルートカウントによる解析的証明。Weyl 群 W(B_n) による全 gh 重みへの拡張。n=1..5 計算的検証。
- [Phase 1-3 統合まとめ](../docs/theory/phase123_summary.md)
  - 判明事実・予想・未解決問題・次方針の整理。


## 4. 参照・調査資料

- [参考文献・関連資料](references.md)
  - 論文・関連リンク。
- [既存ツール調査](existing_tools_lie_superalgebra.md)
  - Lie superalgebra 関連ライブラリの調査メモ。

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
- [next_session/2026-03-28-1.md](next_session/2026-03-28-1.md)
  - 直近の対話形式引き継ぎプロンプト（Step 8/Step 9 対応版）。

## 6. レガシー資料

`_legacy/handover/` に移動済み（参照のみ）：

| ファイル | 内容 |
|---|---|
| `code_structure_v3.md` | コード構造概要 (v3.0) |
| `step6_triviality_handover.md` | Triviality Check v4.1 移行引き継ぎ |
| `phase2a_B_space_exploration_plan.md` | B(0,n) 空間探索計画 |
| `gh_schema_and_gamma_parser_design.md` | gh スキーマ設計メモ |
| `gamma_schema_v3_migration.md` | Gamma 構造 v3.0 移行記録 |
| `schema_v3_migration.md` | v3.0 移行記録 |
| `cartan_generator_algorithm.md` | Cartan アルゴリズム仕様 |
| `oscillator_standard_form.md` | 標準形定義 |
| `inhomogeneous_oscillator_notation.md` | osp(1\|2n) 記法 |
| `B_1_1_design_memo.md` | B(1,1) 設計メモ |
| `Bmn_Implementation_Proposal_ExtraFermion.md` | 補助フェルミオン提案 |
| `schema_v4_design_preparation.md` | v4.0 設計準備 |

補足:
- `code_structure_v41.md` は `_legacy/handover/` に移動済み（現行は `handover/code_structure.md`）。

## 運用メモ

- `handover/` に Markdown ファイルを新規追加・改名・用途変更した場合は、この目次を同時に更新してください。
- リポジトリ内リンクは相対パスで記述してください。

## 更新履歴

- **2026-03-31**: レビュー駆動ワークフロー導入・Frappat 記法統一
  - 新規: `handover/workflow_review.md`（レビュー駆動ワークフロー定義）
  - 新規: `docs/reviews/README.md`（レビューファイル命名規則・構成ガイド）
  - 更新: `handover/notation.md`（§5 ルートベクトル記法追加 — Frappat 準拠、LaTeX マクロ命名規則）
  - 更新: `docs/drafts/triviality_B0n_ja.tex`（マクロ全面改定: `\Edp`/`\Edm`/`\Etdp`/`\Etdm`/`\Edpdp`/`\Edpdm`）
  - 更新: `docs/theory/*.md` 8 ファイル（Frappat 記法に統一）
  - 更新: `handover/README.md`（読了順にレビューワークフロー追加、§3 にレビュー索引追加）

- **2026-03-31**: `normal_order_symmetric.md` を索引に追加
  - `handover/README.md` §3 に `docs/derivations/normal_order_symmetric.md` へのリンクと説明を追加。
  - `handover/theory_vs_implementation.md` Metadata の関連ファイルに同ファイルを追記。

- **2026-03-30**: Step 9 完了・Schema 4 ドキュメント整備
  - `handover/code_structure.md`: Schema 4 層・`coboundary_structure_builder.py`・新スクリプト 2 件追加。
  - `handover/handover_memo_latest.md`: Step 9 完了・ロードマップ・成果物テーブル更新。
  - `README.md`: Schema 4・Step 9 反映。
  - `experiments/README.md`: `verify_f_to_gamma.py`・`generate_coboundary_structure.py` 追加。

- **2026-03-30**: Schema 4 ファイル名を係数エンコードに変更
  - `FMapEncoder` 追加（GhEncoder 同規則 + 分数 `Xo Y` 形式）。
  - `data/coboundary_structures/` のファイル名を `B_{m}_{n}_f_{flat_f}.json` 形式に変更。
  - `docs/json_schema_coboundary_structure.md` を全面改訂（エンコード表・canonical pair 表追加）。

- **2026-03-30**: Step 9 実装（逆方向検証 f → γ）・Schema 4 初版
  - 新規: `src/.../coboundary_structure_builder.py`（Schema 4 ビルダー）
  - 新規: `experiments/verify_f_to_gamma.py`（Step 9 逆方向検証 CLI）
  - 新規: `experiments/generate_coboundary_structure.py`（Schema 4 生成 CLI）
  - 新規: `docs/json_schema_coboundary_structure.md`（Schema 4 / coboundary_f 仕様）
  - 更新: `src/.../cohomology_solver.py`（`reconstruct_gamma_from_f()` をライブラリへ移動）
  - `handover/README.md` に Schema 4 へのリンクを追加。

- **2026-03-28**: handover リンク整合性の更新
  - `code_structure_v41.md` 参照先を `_legacy/handover/` に修正。
  - `next_session/2026-03-28-1.md` への導線を追加。

- **2026-03-28**: 現行コード構造ドキュメントを追加
  - 新規: `code_structure.md`（Schema v5.0 / 現行フロー）
  - 更新: `handover/README.md`（現行版リンク追加、v4.1 をスナップショット扱いに整理）

- **2026-03-28**: Gemini CLI ワークフローの追加
  - 新規: `gemini_cli_workflow.md` (CLI 環境用プロトコル)
  - 更新: `GEMINI.md`, `README.md` (索引と推奨読了順の更新)
- **2026-03-27**: リポジトリ整理（Legacy 移動・バージョン番号削除）
  - Schema v5.0 を現行として確定し、ファイル名から `_v5` を削除。
  - v4.1 以前の設計資料・スクリプトを `_legacy/` へ移動。
  - `handover/README.md` を現行構成に合わせて刷新。
- **2026-03-23**: Schema v4.1 対応・Schema 3（evaluated structure）実装
  - 新規: `docs/json_schema_evaluated_structure.md`（Schema 3 仕様）
  - 新規モジュール: `src/.../evaluated_structure_builder.py`、`src/.../evaluated_structure_parser.py`
  - 新規スクリプト: `experiments/generate_evaluated_structure.py`、`experiments/test_evaluated_structure_parser.py`
  - `docs/json_schema_specification.md` に Schema 3 概要セクション追記
  - README セクション2に JSON スキーマ仕様サブセクション追加
- **2026-03-12**: B(m,n) 構造定数実装完了、ドキュメント整理
  - 新規: `code_structure.md`（v4.0）
  - リネーム: `code_structure.md` → `code_structure_v3.md`
  - 更新: `theory_vs_implementation.md`（§7 追加）
  - `_legacy/handover/` に7ファイル移動
  - README 全面改訂
- **2026-03-08**: Phase 2完了、Schema v4.0設計準備資料追加
- **2026-03-29**: ワークフロー文書の再編成（Method B 導入・共通ルール分離）
  - 新規: `workflow_common.md`（全方式共通ルール）
  - 新規: `workflow_method_b.md`（AIエージェント型 Method B）
  - 改名: `ai_workflow.md` → `workflow_method_a.md`（対話型 Method A）
  - 改名: `session_protocol.md` → `session_protocol_method_a.md`
  - 廃止: `gemini_cli_workflow.md`（内容は `workflow_method_b.md` に統合）
  - 更新: `GEMINI.md`, `.github/copilot-instructions.md` の読込順を新文書構成に合わせ済み
