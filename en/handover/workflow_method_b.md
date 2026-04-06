# AI Workflow — Method B (Issue-Driven Agent)

Method B is an AI agent workflow that uses issues as the basic unit of work.
It assumes an environment where the AI agent has direct access to the local
file system and shell (GitHub Copilot Agent Mode, Gemini CLI, etc.).

Common rules (branching policy, handover documentation) are in
[workflow_common.md](workflow_common.md).

## Prerequisites

- The AI agent must have direct access to the local file system and shell
- [ai_trust_policy.md](ai_trust_policy.md) must be placed in the project

## Required Reading Order (Session Start)

1. [README.md](README.md) (handover index)
2. [workflow_common.md](workflow_common.md) (common rules)
3. **This document** (Method B definition)
4. [ai_trust_policy.md](ai_trust_policy.md) (delegation boundary)
5. [handover_memo_latest.md](handover_memo_latest.md) (current state)
6. `docs/issues/issue_open.md` (check issues)
<!-- CUSTOMIZE: Add project-specific files to reading order -->

## AI Reading Confirmation Protocol

After session start, the AI **must** output the following:

```
[Reading Confirmation]
- Branch: [current branch name]
- Previous results: [1–3 line summary of key results from handover_memo_latest.md]
- Current goals: [goals based on issue_open.md content or user instructions]
- Delegation boundary: ai_trust_policy.md loaded
```

If this output is not provided, the user should refuse to begin work.

## Execution Modes

### Default Mode (Execution)

The AI agent directly reads/writes files and executes commands.
The following operations must be **performed only after user confirmation**:

- Destructive or hard-to-recover operations: `git reset --hard`, `git push --force`,
  data deletion, etc.
- In such cases: present the plan and wait for explicit approval

### Verification-Only Mode

Activated by **"perform verification only"** or equivalent instruction.

- Read-only operations only: code search, file reading, checking test results
- No file writes or git state changes
- Continues until the user explicitly deactivates the mode

## Issue Lifecycle

### Phase 1: Issue Creation (Human)

The human writes issue items in `docs/issues/issue_open.md`.

Minimal structure:
```markdown
Created: YYYY-MM-DD
Category: [verification | research | proposal | implementation]

## I1. Title

### Background
[Motivation and context for this issue]

### Requirements
[Specific work to be done]

### Completion Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

### Phase 2: Issue Detection and Analysis (AI)

1. Check for the existence of `docs/issues/issue_needs_clarification.md`
   - If present, present to the user as **top priority**
2. Check `docs/issues/issue_open.md`
   - If non-placeholder items exist, begin handling them
   - If in template state, idle (follow handover instructions)

### Phase 3: Issue Handling (AI)

For each issue item:

1. **Analyze background and requirements**, identify necessary reference materials
2. **Check delegation boundary**: determine if within scope of ai_trust_policy.md
   - If out of scope → return to `needs_clarification`
3. **Perform response**: code fixes, verification, document updates, etc.
4. **Record results**: append response to the relevant item in issue_open.md
5. **Verify**: run tests, confirm LaTeX compilation, etc.

### Phase 4: Completion Process

1. Update completion criteria checkboxes to `[x]` and add `### Response` section per item
2. Copy the completed file to `docs/issues/done/issue_YYMMDD_NN.md`
3. Reset `issue_open.md` by copying `template_issue_open.md`
4. Add a record to `docs/issues/issue_history.md`
5. Update `handover/handover_memo_latest.md`
6. Git completion (see "Branch Operations" below)

## Core Execution Cycle

**Research → Strategy → Execute**

1. **Research**: Investigate the codebase, verify assumptions. Confirm problem reproduction.
2. **Strategy**: Present a concise implementation plan.
3. **Execute — Plan → Act → Validate**:
   - Plan: implementation and test strategy per subtask
   - Act: surgical changes. Prefer editing existing files over creating new ones
   - Validate: run tests and linters. Validation before session end is mandatory

## Git Workflow

### Branch Operations

| Item | Rule |
|------|------|
| Branch name | `ai/workflow_issue` (fixed, persistent) |
| Work start | AI checks out after user places issue_open.md |
| Merge | Integrate to main with `git merge --squash` |
| Post-merge sync | `git checkout ai/workflow_issue && git merge main` |
| Post-completion state | Both branches synced, `issue_open.md` in template state |

### Commit Messages

```
issue_YYMMDD_NN: [summary]

I1: [response details]
I2: [response details]
...
```

### Mid-Session Branch Completion

When a natural stopping point is reached:

1. Confirm tests pass
2. Update `handover_memo_latest.md`
3. Squash merge to main
4. Sync `ai/workflow_issue` with main
5. Continue work within the same session

## Session End Protocol

### Required (All Sessions)

1. Confirm tests pass (`pytest tests/ -v`)
2. Update `handover_memo_latest.md`
3. Push the branch
4. Squash merge (when work is complete)

### May Be Omitted

The following are **not required** (Git serves as a substitute):

- ~~Create session log in `log/`~~ → replaced by `git log`
- ~~Create next-session instruction file~~ → integrated into `handover_memo_latest.md`

**Rationale**: Eliminate dual management with Git to reduce cognitive overhead.
`log/` is reserved for recording research-level decisions that cannot be replaced by Git.

## Tool Usage

- **Direct editing**: targeted replacements in existing files. Create new files only when necessary
- **Command execution**: directly run tests, builds, and linters
- **Sub-agents**: leverage for batch processing and context efficiency with large outputs
