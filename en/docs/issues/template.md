# Issue Template Definition

## Issue File Schema

### Header

```yaml
Created: YYYY-MM-DD    # Creation date
Category: [category]   # Category (may be left blank; AI assigns based on content)
```

### Items

**Numbering scheme**: `I{NN}-{n}` (NN: 2-digit serial number, n: sub-issue number)

```markdown
## I{NN}-1. Title

### Background
[Motivation and context for this issue]

### Requirements
[Specific work to be done]

### Supplementary Information
#### Deliverable Format
{document / schema / code / decision / script}

#### Related Folders/Files
- {relative path from repository root}

#### Related Issues
{e.g., I07-3}

### Completion Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

Minimal structure (Background, Requirements, Completion Criteria, Supplementary Information may be omitted):

```markdown
## I01-1. Title

Body
```

### Multiple Themes

Separate different themes with `---` (horizontal rule) and increment the issue number:

```markdown
## I08-1. Theme A

...

---

## I09-1. Theme B

...
```

The AI processes each theme sequentially, completing Phase 4 for each before moving to the next.

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
3. Reset `issue_open.md` by copying `template_issue_open.md` (replace `{NN}` with the next number)
4. Add a record to `docs/issues/issue_history.md`
5. Update `handover/handover_memo_latest.md`
6. Squash merge to main, sync branches, push

> **Multiple themes**: Complete Phase 4 for each theme before proceeding to the next.
> On error, leave completed themes as-is and do not enter the next theme.

Post-completion branch state:
- **main**: squash commit
- **ai/workflow_issue**: synced with main via `git reset --hard main && git push --force-with-lease`
- **issue_open.md**: template state on both branches
