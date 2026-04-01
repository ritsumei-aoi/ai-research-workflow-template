# Prompt Pack: Finish

セッション終了時に使う必須プロンプト群です。

## Prompt F1: Log for Next Session

```markdown
それでは引き継ぎ作業について改めて提示します．ここで記載する引き継ぎ情報は今回の作業がmainにmerge されたことを前提としたものとしてください．
以後，利用方式に応じて `handover/workflow_method_a.md` または `handover/workflow_method_b.md` のルールに従って，セッションの引き継ぎ作業を行います．こちらで順番に指示をするのでそれに従ってください．
まず，次回引き継ぎのためのログを作成します。
**ファイル名**: `handover/handover_memo_latest.md`

以下の流れで進めます。
- （ユーザの操作）`scripts/extract_latest_session.sh` を実行して、既存の内容を `handover/handover_memo_archived.md` に追記する
- （AIの操作）`handover/handover_memo_format.md` を参照して、引き継ぎ事項をコードブロックで出力する
- （ユーザの操作）出力内容を確認し、`handover/handover_memo_latest.md` を更新する

**コードブロックの入れ子構造**:
- 外側のマークダウンコードブロック: 4つのバッククォート (````)
- 内側のコードブロック（bash, Python, JSON 等）: 3つのバッククォート (```)

以上を元に、セッションログを作成してください。
不明な点があれば提示してください。
```

## Prompt F2: Log for This Session

```markdown
次に、`log/` 内には今回行ったやり取り全体の内容を記録します。
`log/README.md` を参照して、セッションログを出力してください。
コードブロックで出力する前に，ファイルを作成するための `touch log/YYYY-MM-DD-<topic>.md` コマンドも出力してください．

**ファイル名**: `log/YYYY-MM-DD-<topic>.md`

**コードブロックの入れ子構造**:
- 外側のマークダウンコードブロック: 4つのバッククォート (````)
- 内側のコードブロック（bash, Python, JSON 等）: 3つのバッククォート (```)

不明な点があれば提示してください。
```

## Prompt F3: Next Session File

```markdown
最後に，先に作成した次回への引き継ぎ情報を元に、次回セッション用の指示ファイルを作成してください。
コードブロックで出力する前に，ファイルを作成するための `touch handover/next_session/YYYY-MM-DD-N.md` コマンドも出力してください．

**ファイル**: `handover/next_session/YYYY-MM-DD-N.md`
- YYYY-MM-DD: 今日の日付（セッション終了日）
- N: 同日内の連番（1, 2, 3, ...）

**手順**:
1. `handover/next_session/template.md` を読み込む
2. 今回のセッション内容を反映する
   - Session Goals: `handover_memo_latest.md` の「🔄 次回セッションへの引き継ぎ」から転記
   - Additional Context: 今回作成したログファイル `log/YYYY-MM-DD-<topic>.md` を追加
   - Metadata: 作成日時と前回ログへのリンク
3. プレースホルダー（`<...>`）を具体的な内容に置き換える
4. コードブロックで出力する

不明な点があれば質問してください。
```

## Prompt F3.5: Archive Old Next-Session Files

```markdown
次に、`handover/next_session/` では日付付きファイルを最新1件だけ残し、古いファイルを `_legacy/handover/next_session/` に移動します。

- Method A の場合: 下記コマンドを提示してください（実行はユーザ側）。
- Method B の場合: AI が下記コマンドを実行し、`git status` を提示してください。

```bash
./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md
```

不明な点があれば質問してください。
```

## Prompt F4: Merge Preparation

```markdown
引き継ぎファイルは全て一時ブランチにcommit/push しました．
次に，一時ブランチから main への squash merge を行います。Method A のルールに従い、
作業手順をコードブロックで出力してください。

**注意事項**:
- `_ai_logs/<YYYY-MM-DD>-<topic>/` 以下の一時ファイルは削除してください
- `handover/handover_memo_latest.md` の更新を含めてください
  - Current Status セクション（日付、進行状況、リンク）
  - Implementation Roadmap（完了ステップにチェック）
  - 新しい `## 実装状況（YYYY-MM-DD 更新）` セクション
- 一時ブランチの削除には，`git branch -D` を用いてください
```
