# AI Workflow — Common Rules

This file defines rules shared across all AI-assisted workflow methods.

Method-specific rules are in [workflow_method_a.md](workflow_method_a.md) (interactive dialog),
[workflow_method_b.md](workflow_method_b.md) (issue-driven AI agent),
and [workflow_method_c.md](workflow_method_c.md) (GitHub Agentic Workflow, draft).

Issue-driven workflow is integrated into Method B. When using Method A or C,
issue handling follows the same structure described in [workflow_method_b.md](workflow_method_b.md)
(Phase 1-4), but execution differs by method.

Method comparison and selection guide: [workflow_methods_comparison.md](workflow_methods_comparison.md).

## Method Overview

| Method | Execution | AI File Access | Primary Doc |
|---|---|---|---|
| **Method A** | User (local terminal) | Read-only (attachment / MCP / prompt) | [workflow_method_a.md](workflow_method_a.md) |
| **Method B** | AI agent (direct) | Full (read / write / exec) | [workflow_method_b.md](workflow_method_b.md) |
| **Method C** | GitHub Agentic Workflow | Full (via GitHub) | [workflow_method_c.md](workflow_method_c.md) (Draft) |

## Core Principles

- Plan first, then produce artifacts.
- Ask when requirements are unclear.
- Keep outputs concise and verifiable.
- Keep persisted schemas stable: `schema_version` is required; breaking changes require a version bump.
- Always follow the AI delegation boundary ([ai_trust_policy.md](ai_trust_policy.md)).

## Branching Policy

1. Method B: Fixed `ai/workflow_issue` branch.
2. Method A: `ai/<YYYY-MM-DD>-<topic>` date-topic branches.
3. Method C: `agentic/<issue>-<topic>` issue-based branches.
4. Merge to `main` with `git merge --squash`.
5. Remove unnecessary temporary files before merge.

## Handover Documentation Policy

- `handover_memo_latest.md` holds only the latest session; previous sessions move to
  `handover_memo_archived.md`.
- Exact memo structure and templates are defined in [handover_memo_format.md](handover_memo_format.md).
- Japanese sections in `handover_memo_latest.md` templates are intentionally preserved.

## File and Link Governance

- Use relative links for repository-internal references.
- When adding, renaming, or changing any `handover/*.md` file, update [README.md](README.md)
  in the same change.

## Session Start Checklist

At the start of each session, the agent must:

- [ ] Read handover documents in required order (see [workflow_method_b.md](workflow_method_b.md))
- [ ] Output reading confirmation (Method B required protocol)
- [ ] Confirm current branch or create appropriate branch
- [ ] Review `git status` and `git log --oneline -5`
- [ ] Check `docs/issues/issue_open.md` for pending issues
- [ ] Clarify session goals with the user if not already stated

## Session End Checklist

- [ ] tests pass (`pytest tests/ -v`)
- [ ] `git status` reviewed
- [ ] branch pushed (if applicable)
- [ ] `handover_memo_latest.md` updated
- [ ] temporary files cleaned
- [ ] squash merge prepared or completed
