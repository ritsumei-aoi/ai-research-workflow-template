# docs/issues — イシュー管理

## 概要

このディレクトリは、研究成果物に対するイシュー指摘と回答を記録する。
Method B（イシュー駆動エージェント型ワークフロー）の中核コンポーネントとして機能する。

## 運用フロー

```
1. ユーザが issue_open.md を直接編集して項目を追加
2. AI が issue_open.md の内容を確認 → 項目があれば対応開始
3. 完了 → done/issue_YYMMDD_NN.md にコピー
4. issue_open.md を template_issue_open.md で上書き（テンプレート状態に戻す）
5. 差し戻し → issue_needs_clarification.md を作成
```

### ファイル状態による判定

| ファイル | 意味 |
|---------|------|
| `issue_open.md`（項目あり） | 未対応イシューが存在する → AI は対応を開始 |
| `issue_open.md`（テンプレート状態） | 対応すべきイシューなし |
| `issue_needs_clarification.md` | 差し戻しイシューが存在する → ユーザの追加指示待ち（最優先） |

> テンプレート状態の判定: `## I{N}.` のタイトルが `{タイトル}` のままであればテンプレート状態。

## ファイル構成

```
docs/issues/
├── issue_open.md                 # イシューファイル（常時存在）
├── issue_needs_clarification.md  # 差し戻し（存在時のみ）
├── template.md                    # スキーマ定義
├── template_issue_open.md        # issue_open.md のブランクテンプレート
├── issue_history.md              # 全イシュー対応履歴
├── README.md                      # 本ファイル
└── done/                          # 対応済みイシュー
    └── issue_YYMMDD_NN.md        # 完了ファイル
```

## カテゴリラベル

<!-- CUSTOMIZE: プロジェクトに応じてカテゴリを追加・変更 -->

| カテゴリ | 対象 |
|----------|------|
| `verification` | 計算結果・論理の検証 |
| `research` | 調査・方向性提示 |
| `proposal` | 方針・設計の提案 |
| `implementation` | コード実装・修正 |
| `paper` | 論文の内容・構成 |
| `docs` | ドキュメント全般 |
| `workflow` | ワークフロー・運用方法 |

## 対応済みイシュー一覧

| ファイル | カテゴリ | 対応コミット |
|----------|---------|-------------|
| <!-- entries will be added here --> | | |

## 関連ファイル

- [`template.md`](template.md): スキーマ定義
- [`template_issue_open.md`](template_issue_open.md): `issue_open.md` のブランクテンプレート
- [`issue_history.md`](issue_history.md): 対応履歴（全イシューの要約）
- [`../../handover/workflow_method_b.md`](../../handover/workflow_method_b.md): Method B ワークフロー定義
