# AI Trust Policy (Explicit Definition of AI Delegation Boundaries)

This document explicitly defines the scope of delegation to AI in this project.
It is a required component of Method B (Issue-Driven Agent Workflow) and is
included in the set of documents the AI reads at session start.

## Tasks Delegable to AI

The following tasks may be performed autonomously by the AI:

<!-- CUSTOMIZE: Add or modify items according to your project's nature -->
- **Computational implementation**: implementation and execution of numerical/symbolic computation
- **Test code generation and execution**: creating, running, and reporting test results
- **Document formatting and cross-reference fixes**: fixing LaTeX / Markdown structure
- **Code refactoring**: variable renaming, function consolidation, dead code removal
- **Document draft creation**: handover memos, issue responses, comments
- **Git operations**: commit, push, branch creation/switching, squash merge
- **Data format conversion**: conversion between JSON / CSV / LaTeX tables

## Tasks NOT Delegable to AI (Human Must Perform)

The following tasks require human judgment; AI may only **propose or draft**:

<!-- CUSTOMIZE: Add or modify items according to your project's nature -->
- **Final judgment on the correctness of deliverables** (for math research: correctness of theorems and lemmas)
- **Verification of logical validity of deliverables** (for math research: verification of proof steps)
- **Decisions on adopting new claims or directions**
- **Decisions on publishing papers or deliverables**
- **Issue creation and final prioritization decisions**

## Conditions for Trusting AI Output

AI output is considered trustworthy when all of the following are met:

1. All tests pass
2. A human has read and understood the output
3. Results are consistent with known results (manual calculations, prior research, etc.)
4. No destructive changes (existing tests continue to pass)

## Response When Trust Boundary Is Exceeded

When the AI is asked to make a judgment beyond the delegation scope above:

1. Return it to the issue file as `needs_clarification`
2. Describe specifically what information is needed for the judgment
3. Wait for the human's response before continuing work
