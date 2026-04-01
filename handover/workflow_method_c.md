# AI Workflow — Method C (GitHub Agentic Workflow) [Draft/Proposal]

> **Status: Draft/Proposal** — 本ドキュメントは構想段階であり、まだ運用に入っていない。
> 実運用開始時にこのバナーを除去し、workflow_common.md の Method Overview テーブルに追加すること。

Method C は GitHub Issues と Pull Requests を起点に、
[GitHub Agentic Workflow](https://github.github.io/gh-aw/) を利用して
自動的にコード変更を生成・レビュー・マージするワークフローである。

共通ルール（ブランチ規則、引き継ぎドキュメント、ファイルガバナンス、セッション終了チェックリスト）は
[workflow_common.md](workflow_common.md) に定義されている。

## Method A/B との位置づけ

| 観点 | Method A（対話型） | Method B（エージェント型） | Method C（GitHub Agentic） |
|---|---|---|---|
| 実行主体 | 人間（AI の助言を受けて適用） | AI エージェント（ローカル環境） | GitHub Agentic Workflow（クラウド） |
| 起動トリガー | チャットセッション開始 | チャットセッション開始 | GitHub Issue / PR コメント |
| ファイルアクセス | 読み取り専用 | 完全（読み書き実行） | PR スコープ内（リポジトリ全体） |
| 主な用途 | 理論検討、設計議論 | 実装、検証、ドキュメント更新 | 定型タスク、リファクタリング、CI/CD |
| 人間の関与 | 常時（対話ループ） | 監視＋承認 | Issue 作成 → PR レビュー → マージ |

## 適用場面

### Method C に適したタスク

- **コードリファクタリング**: 命名規則の統一、型アノテーション追加、import 整理
- **ドキュメント更新**: docstring 追加・修正、README 更新、CHANGELOG 生成
- **CI/CD 改善**: GitHub Actions ワークフロー追加・修正、依存関係更新
- **ルーチンメンテナンス**: 非推奨 API の置換、lint 警告の修正、テストカバレッジ向上
- **スキーマ移行の定型部分**: ファイル名変更、フィールドリネーム等の機械的な変更

### Method C を使うべきでないタスク

- **理論の検証**: 数学的・学術的な正当性の確認
  → Method A（対話型）で人間が逐次確認
- **新規証明・理論構成**: 学術的な新規構成
  → Method A/B で人間が深く関与
- **スキーマ設計の意思決定**: `schema_version` の変更を伴う構造変更
  → Method A で設計議論 → Method B で実装
- **引き継ぎドキュメントの更新**: `handover_memo_latest.md` 等のセッション固有情報
  → Method A/B のセッション内で更新

**判断基準**: タスクが「機械的に正しさを検証できる」（テスト通過、lint 通過、型チェック通過）場合は
Method C の候補。「数学的正しさの判断が必要」な場合は Method A/B を使用。

## ワークフロー手順

### Step 1. Issue 作成

GitHub Issue を作成し、タスクの内容を明記する。

```markdown
## タスク

[具体的な変更内容を記述]

## 受け入れ基準

- [ ] pytest tests/ -v が全パス
- [ ] 既存の型アノテーションと整合
- [ ] [その他タスク固有の基準]

## 制約

- handover/ 配下のファイルは変更しない
- schema_version は変更しない
```

Issue ラベルの推奨:
- `agentic`: Method C で対応するタスク
- `refactor`, `docs`, `ci`, `maintenance`: タスク種別

### Step 2. Agentic Workflow トリガー

GitHub Agentic Workflow を Issue またはPR コメントから起動する。

- Agentic Workflow が Issue の内容に基づいて PR を自動生成
- PR ブランチ名は `agentic/<issue-number>-<topic>` を推奨
  （既存の `ai/<YYYY-MM-DD>-<topic>` は Method A/B 用）

### Step 3. 自動検証

PR 作成後、以下が自動的に実行される（CI/CD 設定が必要）：

- `pytest tests/ -v` — 回帰テスト
- lint / type check（設定済みの場合）
- 変更ファイル一覧の確認

### Step 4. 人間によるレビュー

PR のレビューは以下の観点で実施する：

1. **変更スコープの確認**: Issue で指定した範囲に収まっているか
2. **数学的整合性**: 構造定数、記法、理論的前提に影響がないか
3. **既存テストへの影響**: テスト結果の変化がないか
4. **ドキュメント整合性**: 変更に伴うドキュメント更新が含まれているか

**重要**: 数学的内容に触れる変更は、PR 上で慎重にレビューすること。
不明な場合は Method A/B セッションで別途検証する。

### Step 5. マージ

- Squash merge を使用（[workflow_common.md](workflow_common.md) のブランチ規則に準拠）
- コミットメッセージに Issue 番号を含める: `#<issue-number>: [summary]`
- マージ後、Issue を自動クローズ

## レビュー駆動ワークフローとの統合

[workflow_review.md](workflow_review.md) のレビュー駆動ワークフローは Method C でも適用可能：

- `docs/reviews/review_open.md` の指摘のうち、機械的に対応可能なものは
  Issue 化して Method C で処理できる
- ただし、レビュー指摘の**解釈**（数学的意図の理解）は人間が行い、
  Issue に具体的な変更指示として記載する必要がある
- レビュー完了処理（`done/` への移動、`review_history.md` 更新）は
  Method C の PR に含めるか、別途 Method B セッションで実施

## 制限事項と考慮点

### 研究プロジェクト固有の課題

1. **文脈の欠如**: Agentic Workflow はセッション間の文脈を持たない。
   `handover_memo_latest.md` の暗黙知に依存するタスクには不向き。

2. **学術的正しさの保証困難**: 自動生成されたコードが学術的に正しいかどうかは、
   テストだけでは判断できない場合がある。

3. **理論ドキュメントとの整合**: `docs/theory/` 配下の文書との整合性は
   自動検証が困難。人間のレビューが必須。

4. **スキーマ依存**: データスキーマに影響する変更は、
   データファイルとの整合性確認が必要。Method C 単独では危険。

### 運用上の注意

- Method C で生成された PR は、Method B セッションの引き継ぎ対象にならない。
  必要に応じて `handover_memo_latest.md` を手動で更新すること。
- 複数の Method C PR が並行する場合、コンフリクトに注意。
  大きなリファクタリングは逐次的に処理することを推奨。
- Agentic Workflow の実行環境にはリポジトリの Python 環境が必要。
  `requirements.txt` の依存関係が正しくインストールされていることを前提とする。

## 導入に向けた TODO

- [ ] GitHub Agentic Workflow の設定・有効化
- [ ] CI/CD パイプラインの整備（`pytest` 自動実行）
- [ ] Issue テンプレートの作成（Method C 用）
- [ ] 試験運用: 小規模なリファクタリングタスクで検証
- [ ] `workflow_common.md` の Method Overview テーブルに Method C を追加
- [ ] 本ドキュメントの Draft ステータス解除
