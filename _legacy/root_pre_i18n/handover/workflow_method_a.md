# AI Workflow — Method A (Interactive Dialog)

Method A is the default workflow for interactive AI chat sessions where the AI provides
guidance but does not directly execute code or modify files.

Common rules (branching policy, handover documentation, file governance, session end
checklist) are defined in [workflow_common.md](workflow_common.md).

## Scope and Priority

- This file is the Method A operational policy.
- Detailed session procedures are in [session_protocol_method_a.md](session_protocol_method_a.md).
- Handover document index: [README.md](README.md).

## Required Reading Order (Session Start)

1. [README.md](README.md) (handover index)
2. [workflow_common.md](workflow_common.md) (common rules)
3. [workflow_method_a.md](workflow_method_a.md) (this file)
4. [handover_memo_latest.md](handover_memo_latest.md) (current project state)
5. [session_protocol_method_a.md](session_protocol_method_a.md) (detailed procedure)
6. [handover_memo_format.md](handover_memo_format.md) (memo update format)

## Default Workflow (Method A)

1. Create and switch to a temporary branch: `ai/<YYYY-MM-DD>-<topic>`.
2. AI provides file content or exact commands; user applies changes locally.
3. User reports results and changed files (or commits when explicitly needed).
4. AI reviews feedback and iterates.
5. Before merge, remove temporary artifacts if unnecessary.
6. Merge to `main` with squash.

For AI information intake, use these channels in parallel as needed: attachment, prompt code
blocks, and MCP retrieval. Channel choice depends on file size, resource limits, and task purpose.

MCP connection metadata is maintained in [README.md](README.md) under "MCP 参照メタ情報".
For full details (channel selection, MCP standard usage, commit timing, `_ai_logs`,
interruption handling), use [session_protocol_method_a.md](session_protocol_method_a.md).

## Fallback Methods

- **Method A2** (terminal → paste): use when direct output confirmation is needed but file
  attachment is unavailable.
- **Method A3** (direct GitHub Web UI commit): use only when local terminal access is unavailable.

## Next-Session File Rotation (Method A)

After creating `handover/next_session/YYYY-MM-DD-N.md`, the user should archive old dated
next-session files manually:

```bash
./scripts/archive_next_session_prompts.sh --keep handover/next_session/YYYY-MM-DD-N.md
```

Keep only the latest dated file in `handover/next_session/`; move older files to
`_legacy/handover/next_session/`.
