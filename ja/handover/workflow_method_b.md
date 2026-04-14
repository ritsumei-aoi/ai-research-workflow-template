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

人間が `docs/issues/issue_open.md` にイシュー項目を記述する。
`template_issue_open.md` をコピーし、`{NN}` を次のイシュー番号に置換して使用する。

**番号体系**: `I{NN}-{n}`（NN: 2桁通し番号、n: サブイシュー番号）

**複数テーマの記載**: 異なるテーマは `---`（水平線）で区切り、イシュー番号を1つ上げる。
AI は各テーマを順番に処理し、テーマごとに Phase 4 を完了させる。

最小構成：
```markdown
Created: YYYY-MM-DD
Category: [verification | research | proposal | implementation]

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
3. プロジェクト固有の参照資料があれば確認し、必要に応じてユーザに提示する。

### Phase 3: イシュー対応（AI）

各イシュー項目に対して：

1. **背景・要求を分析**し、必要な参照資料を確認
2. **委任境界を確認**: ai_trust_policy.md の範囲内か判定
   - 範囲外の場合 → `needs_clarification` に差し戻し
3. **具体性を優先**: 一般論的な分析よりも、申請者の具体的な環境に即した分析を優先する
4. **変更影響分析**: 既存ファイルに波及する変更がある場合、影響範囲をリスト化してから実行する
5. **対応実施**: コード修正・検証・文書更新等
6. **結果を記録**: issue_open.md の該当項目に回答を追記
7. **検証**: テスト実行、LaTeX コンパイル確認等

### Phase 4: 完了処理

1. `issue_open.md` の完了条件チェックボックスを `[x]` に更新し、各項目に `### 対応` セクションを追記
2. 回答済みファイルを `docs/issues/done/issue_YYMMDD_NN.md` にコピー
3. `issue_open.md` を `template_issue_open.md` の内容でリセット（`{NN}` を次の番号に置換）
4. `docs/issues/issue_history.md` に記録を追加
5. `handover_memo_latest.md` を更新
6. Git 完了処理（下記「ブランチ運用」参照）

> **複数テーマの場合**: 各テーマごとに Phase 4 を完了させてから次のテーマに進む。
> エラー発生時は完了済みテーマはそのまま、次のテーマには入らず終了する。

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
