# イシュー テンプレート定義

## イシューファイルのスキーマ

### ヘッダ

```yaml
Created: YYYY-MM-DD    # 作成日
Category: [category]   # カテゴリ（空欄可、AI が内容から判断して付与）
```

### 項目

**番号体系**: `I{NN}-{n}`（NN: 2桁通し番号、n: サブイシュー番号）

```markdown
## I{NN}-1. タイトル

### 背景
[このイシューの動機・文脈]

### 要求
[具体的な作業内容]

### 補足情報
#### 成果物形式
{文書 / スキーマ / コード / 判断 / スクリプト}

#### 関連フォルダ/ファイル
- {リポジトリルートからの相対パス}

#### 関連issue
{例: I07-3}

### 完了条件
- [ ] 条件1
- [ ] 条件2
```

最小構成（背景・要求・完了条件・補足情報は省略可）:

```markdown
## I01-1. タイトル

本文
```

### 複数テーマの記載

異なるテーマは `---`（水平線）で区切り、イシュー番号を1つ上げる:

```markdown
## I08-1. テーマA

...

---

## I09-1. テーマB

...
```

AI は各テーマを順番に処理し、テーマごとに Phase 4 を完了させる。

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
3. `issue_open.md` を `template_issue_open.md` の内容でリセット（`{NN}` を次の番号に置換）
4. `docs/issues/issue_history.md` に記録を追加
5. `handover/handover_memo_latest.md` を更新
6. `git merge --squash` で main に統合、ブランチ同期、push

> **複数テーマの場合**: 各テーマごとに Phase 4 を完了させてから次のテーマに進む。
> エラー発生時は完了済みテーマはそのまま、次のテーマには入らず終了する。

完了後のブランチ状態:
- **main**: squash commit
- **ai/workflow_issue**: `git reset --hard main && git push --force-with-lease` で main と同期済み
- **issue_open.md**: 両ブランチでテンプレート状態
