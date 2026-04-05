# AI Workflow — Method C (GitHub Agentic Workflow) [Draft/Proposal]

> **Status: Draft/Proposal** — This document is at the conceptual stage and not yet in operation.
> When operational deployment begins, remove this banner and add it to the Method Overview table in workflow_common.md.

Method C is a workflow that uses GitHub Issues and Pull Requests as triggers,
leveraging [GitHub Agentic Workflow](https://github.github.io/gh-aw/) to
automatically generate, review, and merge code changes.

Common rules (branching rules, handover documentation, file governance, session end checklist)
are defined in [workflow_common.md](workflow_common.md).

## Positioning Relative to Methods A/B

| Aspect | Method A (Interactive) | Method B (Agent) | Method C (GitHub Agentic) |
|---|---|---|---|
| Executor | Human (applies AI advice) | AI agent (local environment) | GitHub Agentic Workflow (cloud) |
| Trigger | Chat session start | Chat session start | GitHub Issue / PR comment |
| File access | Read-only | Full (read/write/exec) | PR scope (entire repository) |
| Primary use | Theory discussion, design review | Implementation, verification, doc updates | Routine tasks, refactoring, CI/CD |
| Human involvement | Constant (dialog loop) | Monitoring + approval | Issue creation → PR review → merge |

## Use Cases

### Tasks Suited for Method C

- **Code refactoring**: unifying naming conventions, adding type annotations, organizing imports
- **Documentation updates**: adding/fixing docstrings, README updates, CHANGELOG generation
- **CI/CD improvements**: adding/modifying GitHub Actions workflows, updating dependencies
- **Routine maintenance**: replacing deprecated APIs, fixing lint warnings, improving test coverage
- **Mechanical parts of schema migration**: file renaming, field renaming, and other mechanical changes

### Tasks NOT Suited for Method C

- **Theory verification**: confirming mathematical or academic correctness
  → Use Method A (interactive) for step-by-step human verification
- **Novel proofs/theory construction**: academic novel constructions
  → Use Method A/B with deep human involvement
- **Schema design decisions**: structural changes involving `schema_version` changes
  → Design in Method A → implement in Method B
- **Handover document updates**: session-specific information like `handover_memo_latest.md`
  → Update within Method A/B sessions

**Decision criterion**: If a task can be "mechanically verified for correctness" (tests pass, lint passes, type check passes),
it is a candidate for Method C. If "mathematical correctness judgment is required," use Method A/B.

## Workflow Steps

### Step 1. Create Issue

Create a GitHub Issue with a clear description of the task.

```markdown
## Task

[Describe the specific changes]

## Acceptance Criteria

- [ ] pytest tests/ -v all pass
- [ ] Consistent with existing type annotations
- [ ] [Other task-specific criteria]

## Constraints

- Do not modify files under handover/
- Do not change schema_version
```

Recommended Issue labels:
- `agentic`: tasks to be handled by Method C
- `refactor`, `docs`, `ci`, `maintenance`: task type

### Step 2. Trigger Agentic Workflow

Trigger GitHub Agentic Workflow from an Issue or PR comment.

- Agentic Workflow automatically generates a PR based on the Issue content
- Recommended PR branch name: `agentic/<issue-number>-<topic>`
  (existing `ai/<YYYY-MM-DD>-<topic>` is for Method A/B)

### Step 3. Automated Verification

After PR creation, the following run automatically (CI/CD setup required):

- `pytest tests/ -v` — regression tests
- lint / type check (if configured)
- Review of changed files

### Step 4. Human Review

Review the PR from the following perspectives:

1. **Scope confirmation**: does it stay within the range specified in the Issue?
2. **Mathematical consistency**: no impact on structure constants, notation, or theoretical assumptions?
3. **Impact on existing tests**: no changes in test results?
4. **Documentation consistency**: are related documentation updates included?

**Important**: Changes touching mathematical content must be reviewed carefully on the PR.
If uncertain, verify separately in a Method A/B session.

### Step 5. Merge

- Use squash merge (per branching rules in [workflow_common.md](workflow_common.md))
- Include the Issue number in the commit message: `#<issue-number>: [summary]`
- Auto-close the Issue after merge

## Integration with Review-Driven Workflow

The review-driven workflow from [workflow_issue.md](workflow_issue.md) is also applicable to Method C:

- Among items in `docs/issues/issue_open.md`, mechanically addressable ones can be
  converted to Issues and handled by Method C
- However, the **interpretation** of review comments (understanding mathematical intent)
  must be done by humans and written as specific change instructions in the Issue
- Review completion process (moving to `done/`, updating `issue_history.md`) can be
  included in the Method C PR or handled separately in a Method B session

## Limitations and Considerations

### Research-Project-Specific Challenges

1. **Lack of context**: Agentic Workflow has no inter-session context.
   Not suitable for tasks that depend on implicit knowledge from `handover_memo_latest.md`.

2. **Difficulty ensuring academic correctness**: automatically generated code may not
   always be academically correct, and tests alone may not be sufficient to judge this.

3. **Consistency with theory documents**: consistency with documents under `docs/theory/`
   is difficult to verify automatically. Human review is essential.

4. **Schema dependency**: changes affecting data schemas require consistency checks
   with data files. Dangerous with Method C alone.

### Operational Notes

- PRs generated by Method C are not subject to Method B session handovers.
  Update `handover_memo_latest.md` manually as needed.
- When multiple Method C PRs run in parallel, watch for conflicts.
  It is recommended to process large refactoring tasks sequentially.
- The Agentic Workflow execution environment requires the repository's Python environment.
  It assumes that `requirements.txt` dependencies are correctly installed.

## TODOs for Adoption

- [ ] Set up and enable GitHub Agentic Workflow
- [ ] Prepare CI/CD pipeline (automated `pytest` execution)
- [ ] Create Issue templates (for Method C)
- [ ] Trial run: validate with a small refactoring task
- [ ] Add Method C to the Method Overview table in `workflow_common.md`
- [ ] Remove Draft status from this document
