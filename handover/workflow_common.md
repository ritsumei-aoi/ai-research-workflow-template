# AI Workflow — Common Rules

This file defines rules shared across all AI-assisted workflow methods.

Method-specific rules are in [workflow_method_a.md](workflow_method_a.md) (interactive dialog),
[workflow_method_b.md](workflow_method_b.md) (AI agent with direct execution),
and [workflow_method_c.md](workflow_method_c.md) (GitHub Agentic Workflow, draft).

Review-driven workflow ([workflow_review.md](workflow_review.md)) operates independently of
Method A/B/C and takes priority when `review_open.md` or `review_needs_clarification.md`
exists in `docs/reviews/`.

Method comparison and selection guide: [workflow_methods_comparison.md](workflow_methods_comparison.md).

## Method Overview

| Method | Execution | AI File Access | Primary Doc |
|---|---|---|---|
| **Method A** | User (local terminal) | Read-only (attachment / MCP / prompt) | [workflow_method_a.md](workflow_method_a.md) |
| **Method A2** | User (terminal → paste) | Read-only | [workflow_method_a.md](workflow_method_a.md) (fallback) |
| **Method A3** | User (GitHub Web UI) | None | [workflow_method_a.md](workflow_method_a.md) (fallback) |
| **Method B** | AI agent (direct) | Full (read / write / exec) | [workflow_method_b.md](workflow_method_b.md) |
| **Method C** | GitHub Agentic Workflow | Full (via GitHub) | [workflow_method_c.md](workflow_method_c.md) (Draft) |

## Core Principles

- Plan first, then produce artifacts.
- Ask when requirements are unclear.
- Keep outputs concise and verifiable.
- Keep persisted schemas stable: `schema_version` is required; breaking changes require a version bump.

## Branching Policy

1. Create and switch to a session branch: `ai/<YYYY-MM-DD>-<topic>`.
2. One branch per session as the default. A new branch may be started mid-session when a
   natural work boundary is reached.
3. Merge to `main` with `git merge --squash`.
4. Remove unnecessary temporary files before merge.

## Handover Documentation Policy

- `handover_memo_latest.md` holds only the latest session; previous sessions move to
  `handover_memo_archived.md`.
- Exact memo structure and templates are defined in [handover_memo_format.md](handover_memo_format.md).
- Japanese sections in `handover_memo_latest.md` templates are intentionally preserved.
- Next session instructions are managed in `handover/next_session/`;
  see [next_session/README.md](next_session/README.md) for details.
- Project-wide session logs are stored in `log/`; see [../log/README.md](../log/README.md) for conventions.

## File and Link Governance

- Use relative links for repository-internal references.
- When adding, renaming, or changing any `handover/*.md` file, update [README.md](README.md)
  in the same change.
- For arXiv references, use one entry with both abs and pdf URLs.

## Session Start Checklist

At the start of each session, the agent must:

- [ ] Read handover documents in required order (see [workflow_method_b.md](workflow_method_b.md))
- [ ] Confirm current branch or create `ai/<YYYY-MM-DD>-<topic>` branch
- [ ] Review `git status` and `git log --oneline -5` to understand current state
- [ ] Clarify session goals with the user if not already stated

## Session End Documentation

At the end of each session, create the following:

### 1. Next Session Instructions

**File**: `handover/next_session/YYYY-MM-DD-N.md`

Follow the structure in `handover/next_session/template.md`:
- Session Goals: derived from `handover_memo_latest.md` "次回セッションへの引き継ぎ"
- Required Reading: prioritized list of handover files
- Additional Context: current session outcomes, previous log reference
- Reference Files: key documentation links
- Metadata: session ID, branch name, previous log

See `handover/next_session/README.md` for file structure and naming conventions.

### 2. Session Log

**File**: `log/YYYY-MM-DD-<topic>.md`

Follow the minimal template in `log/README.md`:
- Date and context (what triggered the work)
- Decisions made (and why)
- Actions performed (commands and file changes)
- Next actions (explicit TODO list)
- Links to relevant repo docs

**Purpose**: Project-wide session record, independent from per-repository handover notes.

## Session End Checklist

- [ ] tests pass (`pytest tests/ -v`)
- [ ] `git status` reviewed
- [ ] branch pushed (if applicable)
- [ ] `handover_memo_latest.md` updated
- [ ] next session instructions created
- [ ] session log created
- [ ] temporary files cleaned
- [ ] squash merge plan prepared
