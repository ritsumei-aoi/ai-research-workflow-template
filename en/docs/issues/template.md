# Issue Template Definition

## Issue File Schema

### Header

```yaml
Created: YYYY-MM-DD    # Creation date
Category: [category]   # Category (may be left blank; AI assigns based on content)
```

### Items

```markdown
## I{N}. Title

### Background
[Motivation and context for this issue]

### Requirements
[Specific work to be done]

### Completion Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

Minimal structure (Background, Requirements, Completion Criteria may be omitted):

```markdown
## I1. Title

Body
```

### Response Section (Added by AI after completion)

```markdown
### Response

[Response content]
```

### Cross-cutting Supplementary Section (Optional)

For notes that apply across multiple items, add after the last item:

```markdown
## Supplementary

[Notes applicable to multiple items]
```

## Category Labels

| Category | Scope |
|----------|-------|
| `verification` | Verification of computation results and logic |
| `research` | Investigation and direction proposals |
| `proposal` | Policy and design proposals |
| `implementation` | Code implementation and fixes |
| `paper` | Paper content and structure |
| `docs` | Documentation in general |
| `workflow` | Workflow and operational methods |

<!-- CUSTOMIZE: Add or modify categories according to your project -->

## Completed File Naming Convention

```
done/issue_YYMMDD_NN.md
```

- `YYMMDD`: creation date (6 digits)
- `NN`: sequential number within the same day (2-digit zero-padded)

## Phase 4 (Completion Process)

1. Update completion criteria checkboxes to `[x]` and add `### Response` section per item
2. Copy to `docs/issues/done/issue_YYMMDD_NN.md`
3. Reset `issue_open.md` by copying `template_issue_open.md`
4. Add a record to `docs/issues/issue_history.md`
5. Update `handover/handover_memo_latest.md`
6. Squash merge to main, sync branches, push

Post-completion branch state:
- **main**: squash commit + hash annotation commit
- **ai/workflow_issue**: synced with main (merge commit)
- **issue_open.md**: template state on both branches
