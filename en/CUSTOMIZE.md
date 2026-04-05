# Customization Guide

A step-by-step guide for setting up a new project from this template.

## 1. Initial Repository Setup

1. Create a repository via GitHub's "Use this template"
2. Clone locally
3. Follow the steps below to customize the files

## 2. Files to Customize

Edit files marked with `<!-- CUSTOMIZE -->`.

> **Note:** In this `en/` tree, file paths are relative to `en/`.
> After customization, copy the contents of the `en/` tree to your project root
> (i.e., `en/handover/` → `handover/`, `en/docs/` → `docs/`, etc.).

### Required

| File | What to Change |
|------|----------------|
| `handover/ai_trust_policy.md` | Define project-specific delegable/non-delegable tasks |
| `.github/copilot-instructions.md` | Describe project-specific commands, architecture, and conventions |
| `GEMINI.md` | Add project-specific context files |
| `handover/README.md` | MCP metadata (owner/repo), project-specific document links in §2–4 |
| `handover/workflow_method_b.md` | File list for session-start reading order |
| `README.md` | Project overview and license |

### Recommended

| File | What to Change |
|------|----------------|
| `handover/workflow_methods_comparison.md` | Customize §3 task-specific guide for your project |
| `docs/issues/template.md` | Adjust issue template categories to match your project |

### Before the First Session

| File | Action |
|------|--------|
| `handover/handover_memo_latest.md` | Fill in the initial state |
| `requirements.txt` | Add project dependencies |
| `pytest.ini` | Customize test settings |

## 3. Customization Examples

### Example for `handover/ai_trust_policy.md` (Math Research Project)

```markdown
## Tasks Delegable to AI
- Computational implementation: numerical/symbolic computation with SymPy / NumPy
- Test code generation and execution
- LaTeX formatting and cross-reference fixes

## Tasks NOT Delegable to AI
- Final judgment on the correctness of theorems and lemmas
- Verification of logical validity of proof steps
- Paper submission decisions
```

### Example for `.github/copilot-instructions.md`

```markdown
# Quick commands

- Setup: pip install -e . && pip install -r requirements.txt
- Run tests: pytest tests/ -v
- Validate data: python experiments/validate_data.py

# High-level architecture

- Data-driven pipeline: objects stored as JSON under data/
- Core library: src/my_package/
```

## 4. Removing CUSTOMIZE Markers

After customization is complete, you may either remove or keep the `<!-- CUSTOMIZE -->` markers.

## 5. Deleting Unnecessary Files

The following files may be deleted after customization is complete:

- `CUSTOMIZE.md` (this file)
