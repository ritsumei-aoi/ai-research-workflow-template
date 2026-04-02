# イシュー駆動ワークフロー (Issue-Driven Workflow)

## 概要

`docs/issues/` にイシュー指摘を配置し、AI または人間が対応する仕組み。
Method A（対話型）・Method B（エージェント型）・Method C（GitHub Agentic）の
**いずれでも使用可能**な、独立したワークフロー機構である。

## 動機

- イシュー指摘は Markdown ファイルとして構造化されるため、曖昧さが少ない
- 質問と回答が同一ファイルに残り、対応の完全性を検証しやすい
- ファイルベースのため、対話型でもエージェント型でも同様に機能する
- バージョン管理により、変更履歴が追跡可能

## ファイル構成

```
docs/issues/
├── issue_open.md                 # イシューファイル（常時存在）
├── issue_needs_clarification.md  # 差し戻しイシュー（存在=最優先）
├── template.md                    # スキーマ定義
├── template_issue_open.md        # issue_open.md のブランクテンプレート
├── issue_history.md              # 全イシュー対応履歴
├── README.md                      # レビュー管理インデックス
└── done/                          # 対応済みレビュー
    ├── issue_260331_01.md
    ├── issue_260401_01.md
    └── ...
```

## 優先順位ルール

1. **`issue_needs_clarification.md` が存在**: 最優先。ユーザに差し戻し内容を提示し、具体的な指示を仰ぐ
2. **`issue_open.md` に未対応項目あり**: イシュー対応を開始。引き継ぎ事項より優先
3. **`issue_open.md` がテンプレート状態**: 通常の引き継ぎに従う

> **テンプレート状態の判定**: `## I{N}.` 見出しのタイトルが `{タイトル}` のままであればテンプレート状態。プレースホルダ以外のタイトルがあれば未対応。

矛盾時の優先: イシュー指摘と引き継ぎ事項が矛盾する場合、イシューの指示を優先し、引き継ぎ側を更新する。

## ワークフロー手順

### Step 1. イシュー作成（ユーザ）

`docs/issues/issue_open.md` を直接編集して項目を追加する。
テンプレート状態の `issue_open.md` にはプレースホルダ `{タイトル}` / `{本文}` があるので、
それを実際の内容に書き換える。

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

### Step 2. イシュー検出（セッション開始時）

セッション開始時に以下を確認する：

1. `docs/issues/issue_needs_clarification.md` の有無を確認
   - あれば**最優先**でユーザに差し戻し内容を提示
2. `docs/issues/issue_open.md` の内容を確認
   - `## I{N}.` 見出しのタイトルが `{タイトル}` 以外（＝プレースホルダでない）であれば未対応イシューとして対応開始
   - すべてプレースホルダであればテンプレート状態（＝アイドル）→ 通常の引き継ぎに従う
3. いずれも該当しなければ通常の引き継ぎに従う

### Step 3. イシュー対応（AI）

各項目に対して：

1. 項目の意図を分析し、必要なら参照資料を確認
2. 指示が不明確・不適切な場合：
   - 回答セクションに差し戻し理由を記載
   - `issue_open.md` → `issue_needs_clarification.md` にリネーム
   - コミットして対応を中断
3. 対応可能な場合は `### R{N}. 回答` セクションに回答を記述
4. 必要な修正を関連ファイルに適用
5. LaTeX の場合はコンパイル確認、コードの場合はテスト実行

### Step 4. 完了処理（マージ前）

対応が完了したら、**squash merge の前に**以下を実行する：

1. `issue_open.md` のヘッダを更新：
   - `Answered` に日付を記入
   - `Status` を `done` に変更
2. 回答済みの `issue_open.md` を `done/issue_YYMMDD_NN.md` にコピー：
   - `YYMMDD` は `Created` 日付、`NN` は同日内連番
3. `issue_open.md` を `template_issue_open.md` の内容で上書き（テンプレート状態に戻す）
4. `docs/issues/issue_history.md` に対応記録を追加（統計テーブルも更新）
5. `docs/issues/README.md` のレビュー一覧テーブルを更新

### Step 5. コミットとマージ

Method B の場合、通常の Method B ワークフロー（ブランチ → コミット → squash merge）に従う。
コミットメッセージにイシュー番号を含める：

```
issue_YYMMDD_NN: [summary]

I1: [what was done]
I2: [what was done]
```

### Step 6. ステータス確認（マージ後）

`docs/issues/README.md` のレビュー一覧テーブルにコミットハッシュを記入する。

## Method A/B/C との関係

```
┌─────────────────────────────────────────────┐
│           セッション開始                       │
├─────────────────────────────────────────────┤
│ 1. handover/README.md の読了順に従い読み込み     │
│ 2. docs/issues/ のファイル内容チェック          │
│    ├─ needs_clarification.md 存在 → 最優先     │
│    ├─ issue_open.md に項目あり → イシュー対応  │
│    └─ issue_open.md がテンプレート状態 → 引継ぎ │
├─────────────────────────────────────────────┤
│ Method A: 対話で対応内容を議論→人間が適用        │
│ Method B: AI が直接対応→ブランチ→マージ          │
│ Method C: GitHub Issue/PR + Agentic Workflow   │
└─────────────────────────────────────────────┘
```

イシュー駆動ワークフローは Method A/B/C の**上位**に位置し、
セッションの目標設定に先立って適用される。
