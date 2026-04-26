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

1. Update completion criteria checkboxes to `[x]` and add `### Response` section per item
   - **Important**: Complete this step **before** running `close_issue.sh`. The script assumes checkboxes and `### Response` sections already exist
   - The `--skip-taio-check` flag skips response section validation; do not use it as a rule. If you must use it, record the reason in the `### Response` section or commit message
2. Copy the completed file to `docs/issues/done/issue_YYMMDD_NN.md`
3. Reset `issue_open.md` by copying `template_issue_open.md` (replace `{NN}` with the next number)
4. Add a record to `docs/issues/issue_history.md`
5. Update `handover/handover_memo_latest.md`
6. Git completion (see "Branch Operations" below)

> **Multiple themes**: Complete Phase 4 for each theme before proceeding to the next.
> On error, leave completed themes as-is and do not enter the next theme.

> **Sub-issues (I30-1, I30-2, etc.)**: Sub-issues with the same issue number must be consolidated into **one archive file**. Do not create separate archives per sub-issue. Archive all sub-issues together after all are complete.

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
