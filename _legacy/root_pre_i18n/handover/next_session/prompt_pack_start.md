# Prompt Pack: Start

次セッション開始時に使うプロンプト群です。

## Prompt 0: Session Start

```markdown
# <YYYY-MM-DD> 引き継ぎセッション

## 0. はじめに

これよりこのスレッドで必要な情報を添付します。以下の順番に指示します。

- 1. 論文と作業の概要
- 2. 現状把握と目標設定
- 3. 作業ルールの確認

それぞれにある「あなたのここでの作業」の指示に従ってください。
いずれのステップにおいても、不明な点があれば質問をしても構いません。
準備ができたら「次に進んでください」と回答してください。
```

## Prompt 1: Paper Confirmation

<!-- CUSTOMIZE: Replace with your project's reference paper/resource -->

```markdown
## 1. 論文と作業の概要

### 対象論文
<!-- CUSTOMIZE: Describe your reference paper or resource -->
添付されている **`<reference-file>`** が、このセッションの作業の中心です。

### プロジェクトの目的
<!-- CUSTOMIZE: Describe your project's purpose -->

### あなたのここでの作業

上記の資料を確認し、プロジェクトの主要な定義と構造を把握してください。

確認が完了したら「資料を確認しました。次のステップに進んでください」と回答してください。
```

## Prompt 2: Goal Setting

```markdown
## 2. 現状把握と目標設定

### 2.1 現状把握

現在作成しているファイルは，以下のGitHubレポジトリのものになります：

<!-- CUSTOMIZE: Update with your repository information -->
- owner: `your-github-username`
- repo: `your-repo-name`

あなたはMCPサーバからここにあるファイルを取得できます．ただし，書き込みやGitの操作などはできません．
最初に用いるのは以下になります：
- `handover/README.md`：引き継ぎ情報の概要
- `handover/handover_memo_latest.md`：前回セッションのメモ
これらをMCPサーバから取得して，ファイルの構成を確認して下さい．なお，ここに記載されているファイルも後でMCPサーバから取得して構いません．

### 現状の確認
上記2つのファイルをMCPサーバから確認して，現状を把握して概要を記載してください．それを踏まえたこのセッションの目標や具体的な進め方については次以降のステップで扱います．
```

```markdown
### 2.2 目標の設定

先に読み込んだ
**`handover/handover_memo_latest.md`** を確認して、現在の実装状況と次のステップを把握してください：

**確認項目**:
- **Current Status (最新状況)**: 最終更新日と進行状況の要約
- **Implementation Roadmap (実装ロードマップ)**: 完了済み・未完了のステップ
- **🔄 次回セッションへの引き継ぎ**: 前回からの具体的な課題

### 今回の目標（案）

**プレースホルダー（以下に具体的な目標を記述）**:
<session-goals>

**デフォルト**: 上記が空欄の場合、`handover_memo_latest.md` の「🔄 次回セッションへの引き継ぎ」セクションに記載されている作業を進めてください。

### あなたのここでの作業

これらの情報を踏まえて「今回の目標（案）」を確認・整理してその妥当性を検証してください。
必要に応じて修正案を提示してください．不明な点は質問してください．
実際の進め方は目標が決定した後に提示します．
```

## Prompt 3: Workflow Confirmation

```markdown
## 3. 作業ルールの確認

### ワークフローと更新ルール

MCPサーバから取得した以下によって，作業の進め方とドキュメント更新ルールを把握してください：

- `handover/workflow_common.md`
- `handover/workflow_method_a.md`（対話型）または `handover/workflow_method_b.md`（AIエージェント型）
- `handover/session_protocol_method_a.md`（Method A 詳細）
- `handover_memo_format.md`

**確認項目**:
- **Method A / Method B**: 利用方式に応じたワークフロー
- **ブランチ命名規則**: `ai/<YYYY-MM-DD>-<topic>`
- **Handover Memo Rules**: latest/archived の分割構造、更新タイミング、テンプレート構造
- **Session End Checklist**: セッション終了時の確認事項

### あなたのここでの作業

- 上記ファイルを読み込み、作業ルールを確認する
- 今回用いる一時ブランチの名称を `ai/<YYYY-MM-DD>-<topic>` 形式で決定し、以下を出力する：
  1. ブランチ名
  2. ブランチ作成コマンド（例: `git checkout -b ai/2026-03-03-topic-name`）

次のステップで改めてこのセッションの進め方についてこちらから提案します
```
