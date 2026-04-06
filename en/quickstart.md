# Quick Start Guide

This guide walks you through getting started with the AI Research Workflow Template.
Choose the method that matches your AI environment.

> **Not sure which method to use?** Jump to [Method Z](#method-z-let-your-ai-figure-it-out) at the bottom — it works with any AI.

---

## Prerequisites

1. **Create a repository** from this template (or clone/fork it)
2. **Choose your language**: work within the `en/` or `ja/` directory
3. **Follow [CUSTOMIZE.md](en/CUSTOMIZE.md)** for initial project setup

---

## Method A: Interactive Dialog

**For:** Browser-based AI chat (ChatGPT, Claude, Gemini web, etc.)
where the AI provides guidance and the human applies changes locally.

### What You Need

- An AI chat interface (browser or app)
- A local copy of this repository
- A text editor and terminal

### Getting Started

**Step 1: Prepare your project**

Complete the setup in [CUSTOMIZE.md](en/CUSTOMIZE.md), then fill in:
- `handover/ai_trust_policy.md` — define what the AI may and may not do
- `handover/handover_memo_latest.md` — describe the current state of your project

**Step 2: Start a session**

Open your AI chat and provide context. You can do this by:
- **Attaching files** directly to the chat (recommended for most platforms)
- **Pasting content** into the prompt

Provide at minimum:
- `handover/workflow_common.md`
- `handover/workflow_method_a.md`
- `handover/handover_memo_latest.md`

> **Optional:** Some AI platforms support tool-based file retrieval (e.g., MCP servers
> for GitHub repositories or cloud storage), allowing the AI to read your files directly
> instead of requiring manual attachment.

**Step 3: Example first prompt**

```
I am starting a new session for my research project.
I have attached the workflow rules and handover documents.
Please read them and confirm your understanding of the current state.

Today I would like to work on [describe your task].
```

**Step 4: Work through the session**

The AI will suggest changes; you apply them locally, report results, and iterate.

**Step 5: End the session**

Before closing the chat:
1. Update `handover/handover_memo_latest.md` with what was accomplished
2. Commit and push your changes
3. The updated handover memo ensures the next session (even with a different AI) can continue seamlessly

### Method A Summary

```
You (human)          AI (chat)
    │                    │
    ├─ Attach files ────►│
    │                    ├─ Read & confirm
    │◄── Suggestions ────┤
    ├─ Apply changes     │
    ├─ Report results ──►│
    │                    ├─ Review & iterate
    │◄── Next steps ─────┤
    ├─ Update handover   │
    └─ Commit & push     │
```

---

## Method B: Issue-Driven Agent

**For:** AI agents with direct file system access (GitHub Copilot in VS Code,
Gemini CLI, etc.) where the AI reads/writes files and executes commands autonomously.

### What You Need

- An AI agent with file system and shell access, for example:
  - **GitHub Copilot** (VS Code / CLI) — agent mode
  - **Gemini CLI** — with local workspace access
  - Other AI coding agents with similar capabilities
- A local copy of this repository

### Getting Started

**Step 1: Prepare your project**

Complete the setup in [CUSTOMIZE.md](en/CUSTOMIZE.md), then fill in:
- `handover/ai_trust_policy.md`
- `handover/handover_memo_latest.md`

**Step 2: Create an issue**

Write your task in `docs/issues/issue_open.md` following the template:

```markdown
Created: 2026-04-06
Category: implementation

## I1. Add unit tests for data loader

### Background
The data loader module in `src/loader.py` currently has no test coverage.

### Requirements
Write pytest-based unit tests covering the main loading functions.

### Completion Criteria
- [ ] Tests cover `load_json()` and `load_csv()` functions
- [ ] All tests pass with `pytest tests/ -v`
```

> See [samples/docs/issues/done/](samples/docs/issues/done/) for complete examples
> of issues with AI responses.

**Step 3: Start the AI agent and give the initial prompt**

```
A new issue has been created. Please read docs/issues/issue_open.md
and handle the items according to the workflow defined in
handover/workflow_method_b.md.
```

The AI agent will:
1. Read the workflow rules and handover documents
2. Output a reading confirmation (branch, previous results, current goals)
3. Begin working on the issue items

**Step 4: Monitor and approve**

The AI works autonomously but will ask for confirmation before destructive operations.
Review its progress and provide guidance when needed.

**Step 5: Completion**

The AI follows the Phase 4 completion process automatically:
- Marks completion criteria as done
- Archives the issue to `docs/issues/done/`
- Updates `handover_memo_latest.md`
- Merges to main

> **Note:** This guide assumes the user and AI share the same local environment.
> If you prefer, you can also work with Git-based handoff: commit and push your
> issue file, then have the AI pull and work on a separate machine or environment.

### Method B Summary

```
You (human)              AI (agent)
    │                        │
    ├─ Write issue_open.md   │
    ├─ Start agent ─────────►│
    │                        ├─ Read workflow + handover
    │                        ├─ Output reading confirmation
    │                        ├─ Work on issues
    │◄── Confirm? ───────────┤  (for destructive ops)
    ├─ Approve ─────────────►│
    │                        ├─ Complete & archive
    │                        └─ Update handover & merge
    │
    └─ Review results
```

---

## Method Z: Let Your AI Figure It Out

**For:** Anyone who wants to get started immediately without reading documentation.

This is the simplest possible approach: give your AI (any AI) this repository
and let it determine the best way to use the workflow with your available tools.

### The One Prompt

Copy and paste this into any AI chat:

```
I want to use this AI research workflow template for my project.
Here is the repository: https://github.com/ritsumei-aoi/ai-research-workflow-template

Based on my current environment and the tools I have available,
please suggest:
1. Which method (A, B, or C) is most suitable for me
2. The specific steps to set up and start using it
3. An example first session

After your recommendation, please guide me through the setup step by step.
```

That's it. The AI will read the repository contents, assess your environment,
and walk you through the most appropriate setup.

### Why This Works

The repository is self-documenting: it contains detailed workflow definitions,
comparison guides, customization instructions, and sample issues. Any capable
AI can read these and provide tailored guidance for your specific situation.

> **Tip:** If your AI cannot access URLs directly, download/clone the repository
> and attach the key files (`README.md`, `en/handover/workflow_methods_comparison.md`,
> `en/CUSTOMIZE.md`) to the chat instead.

---

## What's Next?

After your first session, you'll have:
- A customized project with your own `ai_trust_policy.md`
- A `handover_memo_latest.md` recording your project state
- Familiarity with the issue → response → archive cycle

For deeper understanding:
- [Method Comparison Guide](en/handover/workflow_methods_comparison.md) — detailed comparison of all methods
- [Common Rules](en/handover/workflow_common.md) — branching, handover, and session policies
- [Sample Issues](samples/docs/issues/done/) — real examples of completed issues

---

## References

- H. Aoi, *A collaborative workflow for human-AI research in pure mathematics*, Preprint, 2026.
  \[[PDF](aoi2026_collaborative_workflow.pdf)\]
- Case study: [osp-triviality](https://github.com/ritsumei-aoi/osp-triviality)
