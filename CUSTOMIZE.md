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
| `.github/copilot-instructions.md` | プロジェクト固有のコマンド、アーキテクチャ、規約を記述 |
| `GEMINI.md` | プロジェクト固有のコンテキストファイルを追加 |
| `handover/README.md` | MCP メタ情報（owner/repo）、§2-4 のプロジェクト固有資料リンク |
| `handover/workflow_method_b.md` | セッション開始時の読み込みファイルリスト |
| `README.md` | プロジェクト概要、ライセンス |

### 推奨

| ファイル | 変更内容 |
|---------|---------|
| `handover/workflow_methods_comparison.md` | §3 のタスク別ガイドをプロジェクト固有に |
| `handover/workflow_method_c.md` | プロジェクト固有の適用場面・制限事項 |
| `handover/next_session/template.md` | 参照ファイルリスト |
| `handover/next_session/prompt_pack_start.md` | プロジェクト固有のセッション開始プロンプト |
| `docs/theory/README.md` | 理論資料のディレクトリ構成 |

### 初回セッション前

| ファイル | 操作 |
|---------|------|
| `handover/handover_memo_latest.md` | 初期状態を記入 |
| `requirements.txt` | プロジェクトの依存パッケージを追加 |
| `pytest.ini` | テスト設定をカスタマイズ |

## 3. カスタマイズ例

### `.github/copilot-instructions.md` の例

```markdown
# Quick commands

- Setup (editable install):
  - pip install -e .
  - pip install -r requirements.txt
- Run regression tests:
  - pytest tests/ -v
- Validate data:
  - python experiments/validate_data.py

# High-level architecture (big picture)

- Data-driven pipeline: objects stored as JSON under data/
- Core library: src/my_package/
- Experiment scripts: experiments/
```

### `handover/README.md` の MCP メタ情報

```markdown
- owner: `your-github-username`
- repo: `your-project-name`
- base_path: `handover/`
- default_ref: `main`
```

## 4. CUSTOMIZE マーカーの削除

カスタマイズ完了後、`<!-- CUSTOMIZE -->` マーカーは削除しても残しても構いません。
残しておくと、後から新しい項目を追加する際の目印になります。

## 5. 不要ファイルの削除

以下のファイルはカスタマイズ完了後に削除して構いません：

- `CUSTOMIZE.md`（本ファイル）
