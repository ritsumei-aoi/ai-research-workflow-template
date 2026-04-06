# イシュー テンプレート定義

## イシューファイルのスキーマ

### ヘッダ

```yaml
Created: YYYY-MM-DD    # 作成日
Category: [category]   # カテゴリ（空欄可、AI が内容から判断して付与）
```

### 項目

```markdown
## I{N}. タイトル

### 背景
[このイシューの動機・文脈]

### 要求
[具体的な作業内容]

### 完了条件
- [ ] 条件1
- [ ] 条件2
```

最小構成（背景・要求・完了条件は省略可）:

```markdown
## I1. タイトル

本文
```

### 対応セクション（AI が完了時に追加）

```markdown
### 対応

[対応内容]
```

### 横断的な補足セクション（任意）

複数項目にまたがる補足情報がある場合、最後の項目の後に記載:

```markdown
## 補足

[複数項目に関わる補足情報]
```

## カテゴリラベル

| カテゴリ | 対象 |
|----------|------|
| `verification` | 計算結果・論理の検証 |
| `research` | 調査・方向性提示 |
| `proposal` | 方針・設計の提案 |
| `implementation` | コード実装・修正 |
| `paper` | 論文の内容・構成 |
| `docs` | ドキュメント全般 |
| `workflow` | ワークフロー・運用方法 |

<!-- CUSTOMIZE: プロジェクトに応じてカテゴリを追加・変更 -->

## 完了ファイル命名規則

```
done/issue_YYMMDD_NN.md
```

- `YYMMDD`: 作成日（6 桁）
- `NN`: 同日内の連番（2 桁ゼロ埋め）

## Phase 4（完了処理）

1. `issue_open.md` の完了条件チェックボックスを `[x]` に更新し、各項目に `### 対応` セクションを追記
2. `docs/issues/done/issue_YYMMDD_NN.md` にコピー
3. `issue_open.md` を `template_issue_open.md` の内容で上書き（テンプレート状態に戻す）
4. `docs/issues/issue_history.md` に記録を追加
5. `handover/handover_memo_latest.md` を更新
6. `git merge --squash` で main に統合、ブランチ同期、push

完了後のブランチ状態:
- **main**: squash commit + ハッシュ追記 commit
- **ai/workflow_issue**: main と同期済み（merge commit）
- **issue_open.md**: 両ブランチでテンプレート状態
