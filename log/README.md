# log/ — セッションログ

プロジェクト全体のセッション記録を保管するディレクトリ。

## ファイル命名規則

```
log/YYYY-MM-DD-<topic>.md
```

- `YYYY-MM-DD`: セッション日
- `<topic>`: セッションのトピック（英小文字、ハイフン区切り）

## テンプレート

```markdown
# YYYY-MM-DD: <topic>

## Context
<!-- What triggered this work? -->

## Decisions
<!-- Key decisions made and rationale -->

## Actions
<!-- Commands run, files changed -->

## Next
<!-- Explicit TODO items -->

## Links
<!-- Related documents -->
```

## 運用ルール

- 1セッションにつき1ファイル
- セッション終了時に作成（`prompt_pack_finish.md` の手順に従う）
- `handover_memo_latest.md` とは独立した記録（重複OK）
