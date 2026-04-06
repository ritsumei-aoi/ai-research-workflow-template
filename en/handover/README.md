# Handover Table of Contents

This directory is a repository of documents for AI session operations, implementation handovers, and theory/specification notes.

- File links are relative paths from this `handover` directory.

## MCP Reference Metadata

Link resolution in this README is based on `base_path`.

<!-- CUSTOMIZE: Update repository metadata -->
- owner: `your-github-username`
- repo: `your-repo-name`
- base_path: `handover/`
- default_ref: `main`

## 1. Read First (Session Operations)

Recommended reading order (common to all methods):
1. This `README.md`
2. `workflow_common.md` (common rules for all methods)
3. `workflow_method_b.md` (when using AI agent) / `workflow_method_a.md` (when using interactive dialog)
4. `ai_trust_policy.md` (AI delegation boundary)
5. `handover_memo_latest.md`
6. `docs/issues/issue_open.md` (check issues)

- [Common Workflow Rules](workflow_common.md)
  - Common to all methods: method comparison table, branching rules, handover policy, session end checklist.
- [AI Workflow — Method B (Issue-Driven Agent)](workflow_method_b.md)
  - For environments where AI can directly edit files and execute commands (Copilot Chat, Gemini CLI, etc.). Includes issue-driven workflow.
- [AI Workflow — Method C (GitHub Agentic)](workflow_method_c.md) **[Draft]**
  - Automation via GitHub Issues/PRs + Agentic Workflow. For routine tasks.
- [AI Delegation Boundary Policy](ai_trust_policy.md)
  - Explicit definition of tasks delegable and non-delegable to AI.
- [Method Comparison Guide](workflow_methods_comparison.md)
  - Comparison table of Methods A/B/C, selection flowchart, usage guide.
- [AI Workflow — Method A (Interactive Dialog)](workflow_method_a.md)
  - Policy for environments where AI cannot directly execute (browser chat, etc.).
- [Handover Memo Format](handover_memo_format.md)
  - Template definition for `handover_memo_latest.md` / `handover_memo_archived.md`.
- [Handover Memo (Latest)](handover_memo_latest.md)
  - Latest session progress, handover to next session, recent notes.
- [Handover Memo (Archived)](handover_memo_archived.md)
  - Past session history (chronological, append-only).

## 2. Implementation Specifications & Design Documents

<!-- CUSTOMIZE: Add project-specific implementation documents here. Example:
- [Code Structure](code_structure.md)
  - Current module structure, pipeline, processing flow.
- [Notation and Terminology](notation.md)
  - Unified rules for notation and terminology used in this repository.
-->

## 3. Derivations & Theory Documents

> Theory-related files are consolidated in `docs/theory/`. See also [docs/theory/README.md](../docs/theory/README.md).
> Issue records are consolidated in `docs/issues/`. See also [docs/issues/README.md](../docs/issues/README.md).

<!-- CUSTOMIZE: Add project-specific theory documents here. -->

## 4. References & Research Materials

<!-- CUSTOMIZE: Add project-specific references here. -->

## 5. Sample Issues

Example completed issues are available in `/samples/docs/issues/done/`.
These illustrate the full issue lifecycle in both English and Japanese.



## Operational Notes

- When adding, renaming, or changing the purpose of any Markdown file in `handover/`, update this table of contents at the same time.
- Use relative paths for repository-internal links.
