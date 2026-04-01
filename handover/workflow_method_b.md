# AI Workflow — Method B (AI Agent with Direct Execution)

Method B is the default workflow for AI agents that have direct access to the local filesystem
and shell (e.g., GitHub Copilot Chat in agent mode, Gemini CLI). This method supersedes
Method A when the AI agent can read, write, and execute directly.

Common rules (branching policy, handover documentation, file governance, session end checklist)
are defined in [workflow_common.md](workflow_common.md).

## Scope and Priority

- This file takes precedence over [workflow_method_a.md](workflow_method_a.md) when running
  as an agent with direct execution capability.
- All AI agent tools (GitHub Copilot, Gemini CLI, etc.) follow this single file;
  there are no additional tool-specific overrides.
- Handover document index: [README.md](README.md).

## Required Reading Order (Session Start)

1. [README.md](README.md) (handover index)
2. [workflow_common.md](workflow_common.md) (common rules)
3. [workflow_method_b.md](workflow_method_b.md) (this file)
4. [handover_memo_latest.md](handover_memo_latest.md) (current project state)
<!-- CUSTOMIZE: Add project-specific files to reading order, e.g.:
5. [code_structure.md](code_structure.md) (current module/data layout)
6. [notation.md](notation.md) (notation rules)
-->

## Execution Modes

### Default Mode (Execute)

The AI agent reads, writes, and executes directly. The following operations
**require user confirmation before execution**:

- Destructive or hard-to-reverse operations: `git reset --hard`, `git push --force`,
  deleting untracked files, dropping data, etc.
- In these cases: present a plan and wait for explicit user approval.

### Verification-Only Mode

Activated when the user says **「検証のみ行え」** or equivalent
("analysis only", "do not implement", etc.).

- AI performs read-only operations: code search, file reads, test runs (inspect results only).
- No file writes, no git state changes.
- The mode stays active until the user explicitly returns to default mode.

## Git Workflow

1. **Branch**: Create `ai/<YYYY-MM-DD>-<topic>` at session start.
2. **Commit**: Propose a commit message and commit at natural milestones, or when tracking
   and verification become difficult.
3. **Push**: AI executes `git push`. If a credential/passphrase prompt appears,
   control passes to the user; the session resumes after authentication is complete.
4. **Squash merge**: See [workflow_common.md](workflow_common.md) Branching Policy.

### Mid-Session Branch Completion

When a natural work boundary is reached mid-session:

1. Verify tests pass.
2. Update `handover_memo_latest.md`.
3. Squash merge to `main`.
4. Create a new `ai/` branch for the next work unit.
5. Continue in the same chat session.

## Core Execution Cycle

**Research → Strategy → Execute**

1. **Research**: Map the codebase and validate assumptions before making changes.
   Reproduce reported issues before fixing.
2. **Strategy**: Present a concise implementation plan before execution.
3. **Execute — Plan → Act → Validate**:
   - Plan: define implementation and test strategy per sub-task.
   - Act: apply surgical changes. Prefer editing existing files over creating new ones.
   - Validate: run tests and linters. Validation is mandatory before session closure.

## Tool Usage

- **Direct editing**: Use targeted string-replace for existing files; write new files only
  when strictly necessary.
- **Command execution**: Run tests, builds, and linters directly via shell.
- **Sub-agents**: Delegate batch tasks or high-volume output to sub-agents to maintain
  context efficiency.

## Information Intake

When additional context is needed from the user:

1. File attachment (medium/large files, structured artifacts).
2. Prompt code blocks (short snippets).
3. MCP retrieval (repeat lookups, history-aware checks).

MCP metadata is in [README.md](README.md) under "MCP 参照メタ情報".

### MCP Failure Handling

If MCP is unavailable, continue with local tooling (`git status`, `git diff`, file reads).
Use commit as a verification checkpoint if needed.

## Session End

Before finishing, the agent must:

1. Update `handover_memo_latest.md`
   (move previous content to `handover_memo_archived.md` via `bash scripts/extract_latest_session.sh`).
2. Create next session instructions in `handover/next_session/`.
3. Archive old dated next-session files by executing:
  `./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md`
4. Create a session log in `log/`.
5. Verify all tests pass.

See [workflow_common.md](workflow_common.md) for the full checklist and documentation templates.
