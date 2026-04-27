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


#### Phase 1 Note: Submitting issue_open.md via submit-issue.sh

After writing `issue_open.md`, you can run `handover/scripts/submit-issue.sh` to
reset the `ai/workflow_issue` branch to `origin/main` base and commit/push only `issue_open.md`.

```bash
./handover/scripts/submit-issue.sh          # Standard run
./handover/scripts/submit-issue.sh --dry-run  # Dry-run to preview
```

**When this is useful:**
- Cloud agents that need to commit to a branch
- When `ai/workflow_issue` is dirty from previous work

**For local Copilot CLI:** AI can read `issue_open.md` directly without committing it.
Script execution is optional but recommended to ensure a clean state.

> **Note**: If `memo/` files need to be read by AI, ensure they are committed to `main`.
> Otherwise commit them manually after the AI session starts.
The human writes issue items in `docs/issues/issue_open.md`.
Copy `template_issue_open.md` and replace `{NN}` with the next issue number.
The browser form (`docs/tools/issue_form.html`) can be used to prevent missing fields (R10).

**Numbering scheme**: `I{NN}-{n}` (NN: 2-digit serial number, n: sub-issue number)

**Multiple themes**: Separate different themes with `---` (horizontal rule) and increment the issue number.
The AI processes each theme sequentially, completing Phase 4 for each before moving to the next.

#### Phase 1 Supplement: Prompt Guidelines (R18-2)

Guidelines for the prompt (chat input) sent to the AI agent after placing `issue_open.md`.

**Principle**: The prompt **complements** `issue_open.md` and does not **duplicate** its content.
`issue_open.md` is the formal specification; the prompt is the accompanying verbal instruction.

**Content to include in prompts** (things difficult to write in issue_open.md):

| Category | Example | Effect |
|----------|---------|--------|
| **Trigger** | "I created an issue, please handle it" | Instructs AI to start work |
| **Permission grant** | "Feel free to modify without worrying about backward compatibility" | Expands AI autonomy, prevents rework |
| **Behavioral guidance** | "Evaluate objectively without bias" | Suppresses bias in evaluation tasks |
| **Environment info** | "The template is in a sibling directory" | Provides info not inferable from issue_open.md |
| **Priority hints** | "Process the first issue first" | Specifies order for multiple issues |

**Content to exclude from prompts**:
- Repetition of issue background/requirements (already in issue_open.md)
- Additional completion criteria (should be in issue_open.md)

**Traceability**: Since prompts are not logged, instructions that influenced AI decisions (permission grants, behavioral guidance, etc.) should be recorded in the `### Response` section as "Per prompt instruction, ...".

Minimal structure:
```markdown
Created: YYYY-MM-DD
Category: [verification | research | proposal | implementation | paper | docs | workflow]

## I08-1. Title

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

### Phase 2: Issue Detection and Analysis (AI)

1. Check for the existence of `docs/issues/issue_needs_clarification.md`
   - If present, present to the user as **top priority**
2. Check `docs/issues/issue_open.md`
   - If non-placeholder items exist, begin handling them
   - If in template state, idle (follow handover instructions)
   - If **multiple themes** (`---` separator) exist, confirm theme count
3. **Metadata auto-fill (R10)**: If `Created:` or `Category:` headers are blank:
   - `Created:` → fill in the current date (record in `### Response` that it is an estimated value)
   - `Category:` → infer from issue content and fill in (select from 7 categories)
   - If unable to infer, leave blank and continue; fill in upon completion
   - If filled in, update `issue_open.md` immediately
4. Check any project-specific reference materials and present to the user as needed.

### Phase 3: Issue Handling (AI)

For each issue item:

1. **Analyze background and requirements**, identify necessary reference materials
2. **Check delegation boundary**: determine if within scope of ai_trust_policy.md
   - If out of scope → return to `needs_clarification`
3. **Prioritize specificity**: favor analysis grounded in the applicant's concrete context over generic analysis
4. **Change impact analysis (R12)**: if changes propagate to existing files, list the impact scope before executing. Record the pre-execution file list in the `### Response` section
5. **Perform response**: code fixes, verification, document updates, etc.
6. **Record results**: append response as a `### Response` section to the relevant item in issue_open.md. Include the post-execution file list and a summary of actions taken
7. **Verify**: run tests, confirm LaTeX compilation, etc.

### Phase 4: Completion Process

> **Important**: To prevent issues where `issue_history.md` entries and main squash-merge are missed during completion processing, strictly follow the checklist below.

#### Standard Procedure: Execute `close_issue.sh` (Required)

Phase 4 completion is performed by **executing `close_issue.sh`**. Follow the dry-run → confirm → execute flow:

```bash
# 1. Dry-run to preview plan
./handover/scripts/close_issue.sh --dry-run <YYMMDD> <NN> "<label>" <nextNN>

# 2. If plan looks correct, execute
./handover/scripts/close_issue.sh <YYMMDD> <NN> "<label>" <nextNN>
```

Operations performed by `close_issue.sh`:
- Archive issue content to `docs/issues/done/`
- Reset `issue_open.md` to template state
- Stage + commit if `issue_history.md` has changes
- Push to `ai/workflow_issue` → squash merge to main → branch sync

#### Pre-execution Preparation (Manual, Required)

Before running `close_issue.sh`, the following preparations must be completed. The script validates these prerequisites.

1. Update completion criteria checkboxes to `[x]` and add `### Response` section per item
2. **Add entries to `issue_history.md` (Required)**: Append entries for each sub-issue to `docs/issues/issue_history.md`
     - Past incidents showed that missing `issue_history.md` updates caused problems. To prevent this, execute this step first in Phase 4
     - Follow the format of existing records (do not update the `## Statistics` section at the end)
3. Update `handover/handover_memo_latest.md` (manually or via script; see `handover_memo_format.md`)

#### Fallback if `close_issue.sh` Fails

If `close_issue.sh` execution fails:

1. Check error messages and identify the failing pre-check
2. Fix the issue and retry (if you must use `--skip-taio-check`, record your reasoning)
3. If it still fails, perform the following manually:

```bash
# Step 1: Archive
cp <issue_file> docs/issues/done/issue_YYMMDD_NN.md

# Step 2: Reset issue_open.md
sed 's/{NN}/<nextNN>/g' docs/issues/template_issue_open.md > docs/issues/issue_open.md

# Step 3: Staging
git add docs/issues/done/issue_YYMMDD_NN.md docs/issues/issue_open.md
[If issue_history.md changed, stage it too]
[If handover_memo_latest.md changed, stage it too]
[If close_issue.sh itself changed, stage it too]

# Step 4: Commit
git commit -m "<label>"

# Step 5: Push
git push origin ai/workflow_issue

# Step 6: Squash merge to main
git checkout main
git pull origin main
git merge --squash ai/workflow_issue --no-edit
git commit -m "<label> (squash)"
git push origin main

# Step 7: Branch sync
git checkout ai/workflow_issue
git reset --hard main
git push --force-with-lease origin ai/workflow_issue
```

#### Post-execution Confirmation (Required)

After running `close_issue.sh`, verify the following:

1. Confirm squash merge commit exists on main with `git log -1 --oneline main`
2. Confirm `ai/workflow_issue` is synced with main via `git branch -v`
3. Confirm `docs/issues/issue_open.md` is in template state

> **Phase 4 Checklist (AI Mandatory Check)**:
> - [ ] `### Response` section added
> - [ ] `issue_history.md` entry added ← **Execute first in completion process**
> - [ ] `close_issue.sh` executed (archive + merge/push) ← **Required to prevent squash-merge omissions**
> - [ ] `issue_open.md` confirmed in template state ← **Verify after close_issue.sh execution**
> - [ ] `handover_memo_latest.md` updated ← **Complete before close_issue.sh execution**
> - [ ] **main and ai/workflow_issue are synced** ← **Added to prevent squash-merge omissions**
> - [ ] **Squash merge commit exists on main** ← **Added to prevent squash-merge omissions**
> 
> If any item above is incomplete, **do not reset** `issue_open.md` to template state.

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
| Post-merge sync | `git checkout ai/workflow_issue && git reset --hard main && git push --force-with-lease` |
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
