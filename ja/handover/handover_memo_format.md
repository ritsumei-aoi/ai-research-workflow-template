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

1. セッション中に `handover_memo_latest.md` を更新（実装状況を追記）
2. セッション終了時に以下のいずれかを実行:
   - **推奨手動**: `handover_memo_archived.md` に `## 実装状況` セクションを追記してから、`handover_memo_latest.md` を新しいセッション内容で上書き
   - **スクリプト**: `./handover/scripts/extract_latest_session.sh` を実行（`handover_memo_latest.md` に `## 実装状況` セクションがある場合にのみ機能）

> **注意**: `extract_latest_session.sh` は `handover_memo_latest.md` 内の `## 実装状況` 見出しのセクションを抽出します。
> この見出しがない場合、スクリプトはエラー終了します。セクションがあることを確認してください。

## handover_memo_archived.md

`handover_memo_latest.md` から移動されたセッション記録が時系列で追記される。

> **重要**: I08 でこのファイルに I02-I07 の要約を事前に入力した（アーカイブファイルの存在を確認したため）。
> このセクションは `extract_latest_session.sh` による自動追記の代替として手動で初期化した。
> 次セッション以降は正常な運用を期待（`extract_latest_session.sh` で追記される）。

