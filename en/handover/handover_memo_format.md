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

1. At session start, run `scripts/extract_latest_session.sh`
   - The `## Implementation Status` section of `handover_memo_latest.md` is
     appended to `handover_memo_archived.md`
2. Update `handover_memo_latest.md` during the session
3. Final update at session end

## handover_memo_archived.md

Session records moved from `handover_memo_latest.md` are appended in chronological order.
The most recent session is appended at the top.
