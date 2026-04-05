# Issue Template Definition

## Issue File Schema

### Header

```yaml
Created: YYYY-MM-DD    # Creation date (AI replaces "today" with actual date)
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
[What constitutes completion]
```

Minimal structure (Background, Requirements, Completion Criteria may be omitted):

```markdown
## I1. Title

Body
```

### Response Section (Added by AI)

```markdown
### I{N} Response: [Response Title]

[Response content]
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
