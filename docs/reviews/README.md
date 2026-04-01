# docs/reviews — レビュー管理

## 概要

このディレクトリは、研究成果物（LaTeX 文書、コード、理論等）に対するレビュー指摘と回答を記録する。
レビュー駆動ワークフロー（[handover/workflow_review.md](../../handover/workflow_review.md)）の一部として機能する。

## 運用フロー

```
1. ユーザが template.md をコピーして review_open.md を作成
2. AI が review_open.md の存在を検出 → 対応開始
3. 完了 → done/review_YYMMDD_NN.md にリネーム・移動
4. 差し戻し → review_needs_clarification.md にリネーム
```

### ファイル状態による判定

| ファイル | 意味 |
|---------|------|
| `review_open.md` | 未対応レビューが存在する → AI は対応を開始 |
| `review_needs_clarification.md` | 差し戻しレビューが存在する → ユーザの追加指示待ち（最優先） |
| いずれもなし | 対応すべきレビューなし |

## ファイル構成

```
docs/reviews/
├── review_open.md                 # 未対応（存在時のみ）
├── review_needs_clarification.md  # 差し戻し（存在時のみ）
├── template.md                    # スキーマ定義 + 雛形
├── review_history.md              # 全レビュー対応履歴
├── README.md                      # 本ファイル
└── done/                          # 対応済みレビュー
    └── review_YYMMDD_NN.md        # 完了ファイル
```

## 完了ファイル命名規則

```
review_YYMMDD_NN.md
```

- `YYMMDD`: 作成日（6 桁）
- `NN`: 同日内の連番（2 桁ゼロ埋め）
- 完了後に `done/` へ移動

## カテゴリラベル

項目ごとにカテゴリを設定でき、複数ラベルも許可する。

| カテゴリ | 対象 |
|----------|------|
| `latex` | LaTeX 文書の内容・記法・構成 |
| `code` | Python コード・スクリプト |
| `theory` | 数学的理論・証明の正当性 |
| `workflow` | ワークフロー・運用方法 |
| `docs` | ドキュメント全般（README 等） |

## 対応済みレビュー一覧

| ファイル | カテゴリ | 対応コミット | 旧ファイル名 |
|----------|---------|-------------|-------------|

## 関連ファイル

- [`template.md`](template.md): スキーマ定義 + `review_open.md` の雛形
- [`review_history.md`](review_history.md): 対応履歴（全レビューの要約）
- [`../../handover/workflow_review.md`](../../handover/workflow_review.md): レビュー駆動ワークフロー
