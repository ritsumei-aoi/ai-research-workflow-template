# Session Protocol — Method A (Detailed)

This file contains the detailed session procedure for Method A (interactive dialog).

Common rules (branching policy, handover documentation, file governance, session end
checklist) are in [workflow_common.md](workflow_common.md).

## 1. Method A: Local Terminal and Git (Default)

### 1.1 Session Workflow

1. **Branch Creation**
   - Create and switch to `ai/<YYYY-MM-DD>-<topic>`.
2. **File Generation**
   - AI may consume required input via three channels: attachment, prompt code blocks, and MCP retrieval.
   - AI outputs exact code/content in code blocks (default), or attachment-based delivery.
3. **Execution and Verification**
   - User edits locally, runs tests, and reports results.
   - Default: output confirmation (paste content, `git diff`, logs).
   - Exception: commit and push when explicitly requested or strategically useful.
4. **Commit Decision**
   - User decides commit timing by default.
   - AI may suggest commit if verification/tracking becomes difficult.
5. **Feedback Loop**
   - AI reads reported outputs and drives the next step.
6. **Cleanup**
   - Remove unnecessary temporary files before merge.
7. **Merge**
   - Use `git merge --squash` into `main`.

### 1.2 Commit Workflow (When Applicable)

1. AI provides commit commands and message.
2. User executes commands and reports result.
3. AI verifies via available tooling.

Recommended staging patterns:

```bash
# Pattern 1: Tracked session files
git add path/to/file1.py path/to/file2.md handover/doc.md

# Pattern 2: Difficult tracking
git add .

# Pattern 3: Updated tracked files only
git add -u
```

### 1.3 Output File Guidelines

When capturing command output:

1. Directory:
   - `_ai_logs/<branch-topic>/`
2. Filename convention:
   - Use `*_out.txt` suffix (`pytest_out.txt`, `script_execution_out.txt`)
3. Cleanup:
   - Remove `_ai_logs/<branch-topic>/` before final merge if not needed

Example:

```bash
mkdir -p _ai_logs/2026-02-25-example
pytest tests/ -v > _ai_logs/2026-02-25-example/pytest_out.txt 2>&1
```

### 1.4 Information Intake Channels (Attachment / Prompt / MCP)

Method A keeps local editing and execution as the primary path. The following channels are used to provide data to AI.

1. **Attachment channel**
   - Should be used for medium/large files and structured artifacts.
2. **Prompt code-block channel**
   - Should be used for short snippets and immediate context.
   - Should include explicit file/range context when excerpted.
3. **MCP retrieval channel**
   - Should be used for repeat lookups, repository navigation, and history-aware checks.

Channel selection should depend on file size, resource limits, and task purpose. Channels may be combined in one session.

When the same file is supplied through multiple channels, path/ref context should be stated and consistency should be checked before implementation decisions.

### 1.5 MCP Standard Usage

When MCP is used, resolve repository context from [README.md](README.md) "MCP 参照メタ情報":

- `owner`
- `repo`
- `base_path`
- `default_ref`

Operational guidance:

1. Use MCP as a retrieval and verification aid; local working tree remains the source of truth for edits.
2. If MCP content and local content differ, prefer local content for in-session implementation and report the mismatch.
3. For strict verification, cross-check important findings with local artifacts (`git diff`, snippets, command outputs).

### 1.6 MCP Failure Handling

If MCP is unavailable:

- Continue with output-confirmation workflow.
- Use local artifacts (`git status`, `git diff`, pasted file snippets).
- Commit can be used as a verification checkpoint when needed.

## 2. Handover Memo Lifecycle

### 2.1 Session Start

Move previous latest-session implementation block into archive:

```bash
bash scripts/extract_latest_session.sh
```

### 2.2 Session End

Update `handover_memo_latest.md` using the template rules in [handover_memo_format.md](handover_memo_format.md):

- Update fixed sections (Current Status, Roadmap, Guidelines, Future Work).
- Replace the `## 実装状況` section with the current session content.

## 3. Session Interruption Policy

### 3.1 Technical Interruption

1. Create a session-specific handover note:
   - `handover/<topic>_session_<date>.md`
2. Keep incomplete work on temporary branch.
3. Record completed work, incomplete work, and next steps.

### 3.2 Goal Pivot

1. Document pivot reason in a session-specific handover file.
2. Complete new goal if possible, or leave interruption handover.
3. Update `handover_memo_latest.md` only when coherent work is complete.

### 3.3 Planned Multi-Session Work

1. Create tracking file: `handover/<project>_tracking.md`
2. Update every session.
3. Merge only when coherent milestone is complete.

## 4. Session End Checklist

- [ ] `git status` checked
- [ ] branch pushed if required
- [ ] `handover_memo_latest.md` updated
- [ ] temporary files cleaned
- [ ] squash merge path prepared
