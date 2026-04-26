# Handover Memo Format

Template definition for `handover_memo_latest.md` and `handover_memo_archived.md`.

## Template for handover_memo_latest.md

```markdown
# Handover Memo (Latest Session)

## Current Status

- **Last updated**: YYYY-MM-DD
- **Progress**: [summary]

## Implementation Status (Updated YYYY-MM-DD)

### Session Summary

- **Session goal**: [goal]
- **Method**: Method B
- **Branch**: `ai/YYYY-MM-DD-topic`

### Work Performed

1. [Work item 1]
2. [Work item 2]

### Deliverables

| File | Description |
|------|-------------|
| `path/to/file` | Description |

## 🔄 Handover to Next Session

### Short-Term Goals

1. [Goal 1]
2. [Goal 2]

### Notes

- [Notes]

## Guidelines

<!-- CUSTOMIZE: Add project-specific guidelines -->

## Future Work

<!-- CUSTOMIZE: Add long-term goals -->
```

## Update Procedure

1. Update `handover_memo_latest.md` during the session (append Implementation Status section)
2. At session end, do **one** of the following:
   - **Recommended manual**: Copy the Implementation Status section to `handover_memo_archived.md`, then write new content to `handover_memo_latest.md`
   - **Script**: Run `./handover/scripts/extract_latest_session.sh` (only works if Implementation Status section exists in `handover_memo_latest.md`)

> **Note**: The `extract_latest_session.sh` script extracts content under the `## Implementation Status` heading.
> If that section is missing, the script exits with an error.

## handover_memo_archived.md

Session records moved from `handover_memo_latest.md` are appended in chronological order.
The most recent session is appended at the top.

> **Important**: This file was initialized with I02-I07 summaries during I08 (since it was empty).
> Next sessions should use normal operation via `extract_latest_session.sh` for automatic appends.
The most recent session is appended at the top.
