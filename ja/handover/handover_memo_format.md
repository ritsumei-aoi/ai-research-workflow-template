# 引き継ぎメモフォーマット

`handover_memo_latest.md` および `handover_memo_archived.md` のテンプレート定義。

## handover_memo_latest.md のテンプレート

```markdown
# 引き継ぎメモ（最新セッション）

## 現在の状態

- **最終更新**: YYYY-MM-DD
- **進行状況**: [概要]

## 実装状況（YYYY-MM-DD 更新）

### セッション概要

- **セッション目標**: [目標]
- **方式**: Method B
- **ブランチ**: `ai/YYYY-MM-DD-topic`

### 作業内容

1. [作業項目1]
2. [作業項目2]

### 成果物

| ファイル | 内容 |
|---------|------|
| `path/to/file` | 説明 |

## 🔄 次回セッションへの引き継ぎ

### 短期目標

1. [目標1]
2. [目標2]

### 注意事項

- [注意事項]

## ガイドライン

<!-- CUSTOMIZE: プロジェクト固有のガイドラインを追加 -->

## 今後の課題

<!-- CUSTOMIZE: 長期的な目標を追加 -->
```

## 更新手順

1. セッション開始時に `scripts/extract_latest_session.sh` を実行
   - `handover_memo_latest.md` の `## 実装状況` セクションが
     `handover_memo_archived.md` に追記される
2. セッション中に `handover_memo_latest.md` を更新
3. セッション終了時に最終更新

## handover_memo_archived.md

`handover_memo_latest.md` から移動されたセッション記録が時系列で追記される。
最新のセッションが上に来るように追記する。
