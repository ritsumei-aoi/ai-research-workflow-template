# scripts/ — ユーティリティスクリプト

## 汎用スクリプト

| スクリプト | 用途 |
|-----------|------|
| `extract_latest_session.sh` | `handover_memo_latest.md` の内容を `handover_memo_archived.md` に移動 |
| `archive_next_session_prompts.sh` | 旧 next_session ファイルを `_legacy/` に移動 |

## 使い方

### extract_latest_session.sh

```bash
bash scripts/extract_latest_session.sh
```

セッション開始時に実行し、前回の引き継ぎ内容をアーカイブに移動する。

### archive_next_session_prompts.sh

```bash
./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md
```

`--keep` で指定したファイル以外の日付付き next_session ファイルを `_legacy/handover/next_session/` に移動する。
