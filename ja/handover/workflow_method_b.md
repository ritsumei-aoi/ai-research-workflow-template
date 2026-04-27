# AI Workflow — Method B (Issue-Driven Agent)

Method B は、イシューを作業の基本単位とする AI エージェント型ワークフローである。
AI エージェントがローカルファイルシステムとシェルに直接アクセスできる環境
（GitHub Copilot Agent Mode, Gemini CLI 等）を前提とする。

共通ルール（ブランチポリシー、引き継ぎ文書）は
[workflow_common.md](workflow_common.md) を参照。

## 前提条件

- AI エージェントがローカルファイルシステムとシェルに直接アクセスできること
- [ai_trust_policy.md](ai_trust_policy.md) がプロジェクトに配置されていること

## 必須読み込み順序（セッション開始時）

1. [README.md](README.md)（引き継ぎインデックス）
2. [workflow_common.md](workflow_common.md)（共通ルール）
3. **本文書**（Method B 定義）
4. [ai_trust_policy.md](ai_trust_policy.md)（委任境界）
5. [handover_memo_latest.md](handover_memo_latest.md)（現在の状態）
6. `docs/issues/issue_open.md`（イシュー確認）
<!-- CUSTOMIZE: Add project-specific files to reading order -->

## AI 読み込み確認プロトコル

セッション開始後、AI は以下を**必ず出力**すること：

```
【読み込み確認】
- ブランチ: [現在のブランチ名]
- 前回成果: [handover_memo_latest.md の主要成果 1-3 行]
- 今回目標: [issue_open.md の内容またはユーザ指示に基づく目標]
- 委任境界: ai_trust_policy.md 読み込み済み
```

この出力がない場合、ユーザは作業開始を拒否すること。

## 実行モード

### Default Mode（実行）

AI エージェントはファイルの読み書きとコマンド実行を直接行う。
以下の操作は**ユーザ確認の後に実行**すること：

- 破壊的・復元困難な操作: `git reset --hard`, `git push --force`,
  データ削除等
- 上記の場合: 計画を提示し、明示的な承認を待つ

### Verification-Only Mode（検証のみ）

**「検証のみ行え」** またはそれに準ずる指示で有効化。

- 読み取り専用操作のみ: コード検索、ファイル読み取り、テスト結果の確認
- ファイル書き込み・git 状態変更なし
- ユーザが明示的にモードを解除するまで継続

## イシューライフサイクル

### Phase 1: イシュー作成（人間）


#### Phase 1 補足: issue_open.md のブランチ提出（submit-issue.sh）

`issue_open.md` を記述後、`handover/scripts/submit-issue.sh` を実行すると
`ai/workflow_issue` ブランチを `origin/main` ベースにリセットした上で
`issue_open.md` のみをコミット・プッシュできる。

```bash
./handover/scripts/submit-issue.sh          # 通常実行
./handover/scripts/submit-issue.sh --dry-run  # 事前確認
```

**この操作が有効な場面:**
- クラウドエージェントなど、ブランチへのコミットが必要な環境
- `ai/workflow_issue` が前回の作業で汚れていてクリーンな状態を確保したい場合

**ローカル Copilot CLI の場合:** AI はファイルシステムを直接読めるため、
`issue_open.md` をコミットせずとも AI はその内容を読める。
スクリプト実行は任意であるが、クリーンな状態を担保する意味で実行を推奨する。

> **注意**: `issue_open.md` 以外のファイル（例: `memo/` 内の参照資料）を
> AI に読ませたい場合は、`main` にコミット済みであることを確認すること。
> そうでない場合は AI セッション開始後に手動でコミットする。
人間が `docs/issues/issue_open.md` にイシュー項目を記述する。
`template_issue_open.md` をコピーし、`{NN}` を次のイシュー番号に置換して使用する。
ブラウザフォーム（`docs/tools/issue_form.html`）を利用すると入力漏れを防止できる。

**番号体系**: `I{NN}-{n}`（NN: 2桁通し番号、n: サブイシュー番号）

**複数テーマの記載**: 異なるテーマは `---`（水平線）で区切り、イシュー番号を1つ上げる。
AI は各テーマを順番に処理し、テーマごとに Phase 4 を完了させる。

#### Phase 1 補足: プロンプトガイドライン

`issue_open.md` を配置した後、AIエージェントに送るプロンプト（チャット入力）の指針。

**原則**: プロンプトは `issue_open.md` を**補完**するものであり、内容を**重複**させない。
`issue_open.md` が作業の正式な仕様書であり、プロンプトはそれに付随する口頭指示に相当する。

**プロンプトに含めるべき内容**（issue_open.md に書きにくいもの）:

| 分類 | 例 | 効果 |
|------|-----|------|
| **トリガー** | 「issueを作成したので対応してください」 | AI に作業開始を指示 |
| **権限付与** | 「後方互換性は気にせず自由に修正して」 | AI の自律性を拡大し、手戻りを防止 |
| **行動指針** | 「忖度なく客観的に評価して」 | 評価タスクのバイアスを抑制 |
| **環境情報** | 「テンプレートは並列ディレクトリにある」 | issue_open.md から推測不可能な情報を補完 |
| **優先度ヒント** | 「最初のissueから順番に」 | 複数イシュー時の処理順序を指定 |

**プロンプトに含めるべきでない内容**:
- イシューの背景・要求の繰り返し（issue_open.md に記載済み）
- 完了条件の追加（issue_open.md に書くべき）

**追跡可能性**: プロンプトはログに残らないため、AI の判断に影響した指示（権限付与・行動指針等）は `### 対応` セクションに「プロンプト指示により〇〇」と記録する。

最小構成：
```markdown
Created: YYYY-MM-DD
Category: [verification | research | proposal | implementation | paper | docs | workflow]

## I08-1. タイトル

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

### Phase 2: イシュー検出と分析（AI）

1. `docs/issues/issue_needs_clarification.md` の有無を確認
   - あれば**最優先**でユーザに提示
2. `docs/issues/issue_open.md` を確認
   - プレースホルダでない項目があれば対応開始
   - テンプレート状態であればアイドル（引き継ぎに従う）
   - **複数テーマ**（`---` 区切り）がある場合、テーマ数を確認
3. **メタデータ自動補完**: ヘッダの `Created:` や `Category:` が空欄の場合：
   - `Created:` → 現在の日付を記入（推定値であることを `### 対応` に記録）
   - `Category:` → イシュー内容から推定して記入（7カテゴリから選択）
   - 推定不可能な場合は空欄のまま作業を継続し、完了時に埋める
   - 補完した場合は `issue_open.md` をその場で更新する
4. プロジェクト固有の参照資料があれば確認し、必要に応じてユーザに提示する。

### Phase 3: イシュー対応（AI）

各イシュー項目に対して：

1. **背景・要求を分析**し、必要な参照資料を確認
2. **委任境界を確認**: ai_trust_policy.md の範囲内か判定
   - 範囲外の場合 → `needs_clarification` に差し戻し
3. **具体性を優先**: 一般論的な分析よりも、申請者の具体的な環境に即した分析を優先する
4. **変更影響分析**: 既存ファイルに波及する変更がある場合、影響範囲をリスト化してから実行する。影響ファイル一覧（事前）は `### 対応` セクションに記録する
5. **対応実施**: コード修正・検証・文書更新等
6. **結果を記録**: issue_open.md の該当項目に `### 対応` セクションとして回答を追記。影響ファイル一覧（事後）と対応内容の要約を含める
7. **検証**: テスト実行、LaTeX コンパイル確認等

### Phase 4: 完了処理

> **重要**: `issue_history.md` へのエントリ追記と main への squash merge が完了処理の間に欠落する問題を防止するため、以下のチェックリストを**厳密に遵守**すること。

#### 標準手順: `close_issue.sh` の実行（必須）

Phase 4 の完了処理は **`close_issue.sh` の実行** によって行う。以下のように dry-run→確認→本実行の順序で実施すること。

```bash
# 1. dry-run で計画確認
./handover/scripts/close_issue.sh --dry-run <YYMMDD> <NN> "<label>" <nextNN>

# 2. 計画に問題なければ、本実行
./handover/scripts/close_issue.sh <YYMMDD> <NN> "<label>" <nextNN>
```

`close_issue.sh` が実行する操作:
- `docs/issues/done/` へのアーカイブ（イシュー内容の保存）
- `issue_open.md` のテンプレートリセット
- `issue_history.md` が変更済みならステージ + コミット
- `ai/workflow_issue` への push → main への squash merge → ブランチ同期

#### close_issue.sh 実行前の準備（手動、必須）

`close_issue.sh` を実行する**前に**以下の準備を完了させること。スクリプトはこれらの前提を検証する。

1. `issue_open.md` の完了条件チェックボックスを `[x]` に更新し、各項目に `### 対応` セクションを追記
2. **`issue_history.md` へのエントリ追記（必須）**: 各サブイシューのエントリを `docs/issues/issue_history.md` に追記
    - `issue_history.md` の更新漏れが問題の原因となった。これを防止するため、Phase 4 の最初に実行する
    - フォーマットは既存の記録を参照（末尾の `## 統計` を更新しないこと）
3. `handover_memo_latest.md` を更新（手動またはスクリプトで、`handover_memo_format.md` 参照）

#### close_issue.sh が失敗した場合のフォールバック

`close_issue.sh` の実行が失敗した場合:

1. エラーメッセージを確認し、問題のある pre-check を特定する
2. 問題を修正して再試行する（やむを得ず `--skip-taio-check` を使用する場合は理由を記録）
3. 依然として失敗する場合、手動で以下の操作を行う:

```bash
# Step 1: アーカイブ
cp <issue_file> docs/issues/done/issue_YYMMDD_NN.md

# Step 2: issue_open.md リセット
sed 's/{NN}/<nextNN>/g' docs/issues/template_issue_open.md > docs/issues/issue_open.md

# Step 3: Staging
git add docs/issues/done/issue_YYMMDD_NN.md docs/issues/issue_open.md
[条件: issue_history.md が変更済みなら追加]
[条件: handover_memo_latest.md が変更済みなら追加]
[条件: close_issue.sh 自体が変更済みなら追加]

# Step 4: Commit
git commit -m "<label>"

# Step 5: Push
git push origin ai/workflow_issue

# Step 6: Squash merge to main
git checkout main
git pull origin main
git merge --squash ai/workflow_issue --no-edit
git commit -m "<label> (squash)"
git push origin main

# Step 7: ブランチ同期
git checkout ai/workflow_issue
git reset --hard main
git push --force-with-lease origin ai/workflow_issue
```

#### close_issue.sh 実行後の確認（必須）

`close_issue.sh` の実行後、以下の確認を行う:

1. `git log -1 --oneline main` で squash merge コミットが main にあることを確認
2. `git branch -v` で `ai/workflow_issue` と main が同期していることを確認
3. `docs/issues/issue_open.md` がテンプレート状態であることを確認

> **Phase 4 チェックリスト（AI 必須確認）**:
> - [ ] `### 対応` セクション追記済み
> - [ ] `issue_history.md` エントリ追加済み ← **完了処理の最初に実行**
> - [ ] `close_issue.sh` 執行済み（archive + merge/push）← **squash merge 漏れ防止のため必須**
> - [ ] `issue_open.md` がテンプレート状態であることを確認 ← **close_issue.sh 実行後に確認**
> - [ ] `handover_memo_latest.md` 更新済み ← **close_issue.sh 実行前に完了**
> - [ ] **main と ai/workflow_issue が同期していることを確認** ← **squash merge 漏れ防止のため追加**
> - [ ] **squash merge コミットが main に存在することを確認** ← **squash merge 漏れ防止のため追加**
> 
> 上記のいずれかが欠落している場合、issue_open.md のテンプレートリセットは**行わない**。

## Core Execution Cycle

**Research → Strategy → Execute**

1. **Research**: コードベースの調査、前提の検証。問題の再現確認。
2. **Strategy**: 簡潔な実装計画の提示。
3. **Execute — Plan → Act → Validate**:
   - Plan: サブタスクごとの実装・テスト戦略
   - Act: 外科的変更。新規作成より既存ファイル編集を優先
   - Validate: テスト・リンター実行。セッション終了前の検証は必須

## Git ワークフロー

### ブランチ運用

| 項目 | ルール |
|------|--------|
| ブランチ名 | `ai/workflow_issue`（固定、永続） |
| 作業開始 | ユーザが issue_open.md を配置後、AI がチェックアウト |
| マージ | `git merge --squash` で main に統合 |
| マージ後同期 | `git checkout ai/workflow_issue && git reset --hard main && git push --force-with-lease` |
| 完了後状態 | 両ブランチ同期済み、`issue_open.md` はテンプレート状態 |

### コミットメッセージ

```
issue_YYMMDD_NN: [要約]

I1: [対応内容]
I2: [対応内容]
...
```

### Mid-Session Branch Completion

自然な区切りに達した場合：

1. テスト通過確認
2. `handover_memo_latest.md` 更新
3. main に squash merge
4. `ai/workflow_issue` を main と同期
5. 同一セッション内で作業継続

## セッション終了プロトコル

### 必須（全セッション）

1. テスト通過確認（`pytest tests/ -v`）
2. `handover_memo_latest.md` の更新
3. ブランチの push
4. squash merge（作業完了時）

### 省略可能

以下は**不要**とする（Git が代替）：

- ~~`log/` へのセッションログ作成~~ → `git log` で代替
- ~~次回セッション指示ファイルの作成~~ → `handover_memo_latest.md` に統合

**理由**: Git との二重管理を解消し認知コストを削減する。
`log/` は Git で代替不可能な研究的判断の記録に限定して使用する。

## Tool Usage

- **Direct editing**: 既存ファイルへの対象指定置換。新規ファイルは必要時のみ
- **Command execution**: テスト・ビルド・リンターの直接実行
- **Sub-agents**: バッチ処理や大量出力のコンテキスト効率化に活用
