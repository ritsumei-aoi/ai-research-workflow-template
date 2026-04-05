# カスタマイズ手順書

このテンプレートからプロジェクトを立ち上げる際の手順書。

## 1. リポジトリの初期設定

1. GitHub の "Use this template" からリポジトリを作成
2. ローカルにクローン
3. 以下の手順でファイルをカスタマイズ

## 2. カスタマイズ対象ファイル

`<!-- CUSTOMIZE -->` マーカーが付いたファイルを編集してください。

### 必須

| ファイル | 変更内容 |
|---------|---------|
| `handover/ai_trust_policy.md` | プロジェクト固有の委任可能/不可タスクを定義 |
| `.github/copilot-instructions.md` | プロジェクト固有のコマンド、アーキテクチャ、規約を記述 |
| `GEMINI.md` | プロジェクト固有のコンテキストファイルを追加 |
| `handover/README.md` | MCP メタ情報（owner/repo）、§2-4 のプロジェクト固有資料リンク |
| `handover/workflow_method_b.md` | セッション開始時の読み込みファイルリスト |
| `README.md` | プロジェクト概要、ライセンス |

### 推奨

| ファイル | 変更内容 |
|---------|---------|
| `handover/workflow_methods_comparison.md` | §3 のタスク別ガイドをプロジェクト固有に |
| `docs/issues/template.md` | イシューテンプレートのカテゴリをプロジェクトに合わせる |

### 初回セッション前

| ファイル | 操作 |
|---------|------|
| `handover/handover_memo_latest.md` | 初期状態を記入 |
| `requirements.txt` | プロジェクトの依存パッケージを追加 |
| `pytest.ini` | テスト設定をカスタマイズ |

## 3. カスタマイズ例

### `handover/ai_trust_policy.md` の例（数学研究プロジェクト）

```markdown
## AI に委任可能なタスク
- 計算実装: SymPy / NumPy を用いた数値計算・記号計算
- テストコード生成・実行
- LaTeX の整形・クロスリファレンス修正

## AI に委任してはならないタスク
- 定理・補題の正しさの最終判断
- 証明ステップの論理的妥当性の確認
- 論文の投稿判断
```

### `.github/copilot-instructions.md` の例

```markdown
# Quick commands

- Setup: pip install -e . && pip install -r requirements.txt
- Run tests: pytest tests/ -v
- Validate data: python experiments/validate_data.py

# High-level architecture

- Data-driven pipeline: objects stored as JSON under data/
- Core library: src/my_package/
```

## 4. CUSTOMIZE マーカーの削除

カスタマイズ完了後、`<!-- CUSTOMIZE -->` マーカーは削除しても残しても構いません。

## 5. 不要ファイルの削除

以下のファイルはカスタマイズ完了後に削除して構いません：

- `CUSTOMIZE.md`（本ファイル）
