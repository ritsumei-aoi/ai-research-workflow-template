# レビュー駆動ワークフロー (Review-Driven Workflow)

## 概要

`docs/reviews/` にレビュー指摘を配置し、AI または人間が対応する仕組み。
Method A（対話型）・Method B（エージェント型）・Method C（GitHub Agentic）の
**いずれでも使用可能**な、独立したワークフロー機構である。

## 動機

- レビュー指摘は Markdown ファイルとして構造化されるため、曖昧さが少ない
- 質問と回答が同一ファイルに残り、対応の完全性を検証しやすい
- ファイルベースのため、対話型でもエージェント型でも同様に機能する
- バージョン管理により、変更履歴が追跡可能

## ファイル構成

```
docs/reviews/
├── review_open.md                 # 未対応レビュー（存在=対応必要）
├── review_needs_clarification.md  # 差し戻しレビュー（存在=最優先）
├── template.md                    # スキーマ定義 + review_open.md の雛形
├── review_history.md              # 全レビュー対応履歴
├── README.md                      # レビュー管理インデックス
└── done/                          # 対応済みレビュー
    ├── review_260331_01.md
    ├── review_260401_01.md
    └── ...
```

## 優先順位ルール

1. **`review_needs_clarification.md` が存在**: 最優先。ユーザに差し戻し内容を提示し、具体的な指示を仰ぐ
2. **`review_open.md` が存在**: レビュー対応を開始。引き継ぎ事項より優先
3. **いずれも存在しない**: 通常の引き継ぎに従う

矛盾時の優先: レビュー指摘と引き継ぎ事項が矛盾する場合、レビューの指示を優先し、引き継ぎ側を更新する。

## ワークフロー手順

### Step 1. レビュー作成（ユーザ）

`docs/reviews/template.md` をコピーして `docs/reviews/review_open.md` を作成する。

最小構成:
```markdown
Created: today
Category:

## I1. タイトル

本文
```

- `Created: today` → AI が実際の日付に置換
- `Category:` 空欄 → AI が内容から判断して付与
- 種別タグ・回答セクション・Status 等は省略可（AI が追加）

### Step 2. レビュー検出（セッション開始時）

セッション開始時に以下を確認する：

1. `docs/reviews/review_needs_clarification.md` の有無を確認
   - あれば**最優先**でユーザに差し戻し内容を提示
2. `docs/reviews/review_open.md` の有無を確認
   - あれば未対応レビューとして対応開始
3. いずれもなければ通常の引き継ぎに従う

### Step 3. レビュー対応（AI）

各項目に対して：

1. 項目の意図を分析し、必要なら参照資料を確認
2. 指示が不明確・不適切な場合：
   - 回答セクションに差し戻し理由を記載
   - `review_open.md` → `review_needs_clarification.md` にリネーム
   - コミットして対応を中断
3. 対応可能な場合は `### R{N}. 回答` セクションに回答を記述
4. 必要な修正を関連ファイルに適用
5. LaTeX の場合はコンパイル確認、コードの場合はテスト実行

### Step 4. 完了処理（マージ前）

対応が完了したら、**squash merge の前に**以下を実行する：

1. `review_open.md` のヘッダを更新：
   - `Answered` に日付を記入
   - `Status` を `done` に変更
2. ファイルをリネーム・移動：
   - `review_open.md` → `done/review_YYMMDD_NN.md`
   - `YYMMDD` は `Created` 日付、`NN` は同日内連番
3. `docs/reviews/review_history.md` に対応記録を追加（統計テーブルも更新）
4. `docs/reviews/README.md` のレビュー一覧テーブルを更新

### Step 5. コミットとマージ

Method B の場合、通常の Method B ワークフロー（ブランチ → コミット → squash merge）に従う。
コミットメッセージにレビュー番号を含める：

```
review_YYMMDD_NN: [summary]

I1: [what was done]
I2: [what was done]
```

### Step 6. ステータス確認（マージ後）

`docs/reviews/README.md` のレビュー一覧テーブルにコミットハッシュを記入する。

## Method A/B/C との関係

```
┌─────────────────────────────────────────────┐
│           セッション開始                       │
├─────────────────────────────────────────────┤
│ 1. handover/README.md の読了順に従い読み込み     │
│ 2. docs/reviews/ のファイル存在チェック          │
│    ├─ needs_clarification.md → 最優先で確認    │
│    ├─ review_open.md → レビュー駆動ワークフロー │
│    └─ いずれもなし → 通常の引き継ぎに従う        │
├─────────────────────────────────────────────┤
│ Method A: 対話で対応内容を議論→人間が適用        │
│ Method B: AI が直接対応→ブランチ→マージ          │
│ Method C: GitHub Issue/PR + Agentic Workflow   │
└─────────────────────────────────────────────┘
```

レビュー駆動ワークフローは Method A/B/C の**上位**に位置し、
セッションの目標設定に先立って適用される。
