# Workflow Method Comparison Guide (Methods A / B / C)

This document compares the three AI-assisted workflow methods and provides
guidelines for selecting the appropriate method for a given task.

Details for each method:
- [workflow_method_a.md](workflow_method_a.md) (Method A: Interactive Dialog)
- [workflow_method_b.md](workflow_method_b.md) (Method B: AI Agent)
- [workflow_method_c.md](workflow_method_c.md) (Method C: GitHub Agentic Workflow) **[Draft]**
- [workflow_common.md](workflow_common.md) (Common rules for all methods)
- [workflow_issue.md](workflow_issue.md) (Review-driven workflow — common to all methods)

## 1. Method Comparison Table

| Aspect | Method A (Interactive) | Method B (Agent) | Method C (GitHub Agentic) |
|---|---|---|---|
| **Interaction** | Human-AI dialog loop | AI executes autonomously, human monitors | Issue → auto PR → review |
| **Human involvement** | Constant (all steps) | Monitoring + approval at key points | Issue creation + PR review |
| **AI file access** | Read-only | Full (read/write/exec) | PR scope (entire repository) |
| **Suited tasks** | Theory review, design discussion, proof construction | Implementation, verification, documentation | Refactoring, routine maintenance |
| **Context persistence** | Within session (chat history) | Within session (via handover) | None (Issue description only) |
| **Git workflow** | `ai/<date>-<topic>` → squash merge | `ai/<date>-<topic>` → squash merge | `agentic/<issue>-<topic>` → squash merge |
| **Tool requirements** | Browser / chat UI | Copilot CLI / Gemini CLI, etc. | GitHub Agentic Workflow |
| **Session records** | handover_memo + log/ | handover_memo + log/ | Issue / PR only |
| **Immediate feedback** | ◎ (real-time dialog) | ○ (review results as they come) | △ (review after PR is complete) |
| **Mathematical correctness assurance** | ◎ (human verifies step by step) | ○ (tests + human monitoring) | △ (test-dependent, review required) |

## 2. Method Selection Flowchart

```
Want to execute a task
│
├─ Does it require mathematical theory review or proof?
│   ├─ Yes → Deep human involvement needed
│   │         ├─ AI can execute directly in environment?
│   │         │   ├─ Yes → Method B (use verification-only mode)
│   │         │   └─ No  → Method A
│   │         └─ Constructing a new proof?
│   │             └─ Yes → Method A (build step by step through dialog)
│   │
│   └─ No → Implementation / maintenance task
│           │
│           ├─ Can the task be defined mechanically?
│           │   (Correctness can be judged by test pass)
│           │   ├─ Yes → What is the task size?
│           │   │         ├─ Small–Medium (single purpose) → Method C
│           │   │         └─ Large (multiple steps)         → Method B
│           │   │
│           │   └─ No → Decisions needed during execution
│           │           ├─ AI can execute directly in environment?
│           │           │   ├─ Yes → Method B
│           │           │   └─ No  → Method A
│           │           └─ Involves schema_version change?
│           │               └─ Yes → Method A for design → Method B for implementation
│           │
│           └─ Documentation-only change?
│               ├─ Routine (docstring, README) → Method C
│               └─ Theory documentation → Method A/B
```

## 3. Task-Specific Guide

<!-- CUSTOMIZE: Add project-specific task examples for each method. -->
<!-- Below are generic examples. Replace with your project's actual tasks. -->

### Tasks for Method A

| Task Example | Reason |
|---|---|
| Mathematical theory verification / proof construction | Human judgment is essential at each step of the proof |
| Schema design decisions | Broad impact; consensus through dialog is needed |
| Changes to notation and conventions | Affects everything; requires careful discussion |

### Tasks for Method B

| Task Example | Reason |
|---|---|
| Implementing a new module | Consistent code generation + test execution |
| Developing computational verification scripts | Develop while immediately checking execution results |
| Adding/modifying tests | Add while confirming consistency with existing tests |
| Updating handover documents | Updates based on session context |

### Tasks for Method C (After Adoption)

| Task Example | Reason |
|---|---|
| Bulk addition of type annotations | Mechanical changes, verifiable by tests |
| Adding docstrings / formatting unification | Template-like work |
| Adding GitHub Actions workflows | CI/CD can be verified independently |
| Fixing lint warnings | Mechanical fixes |

## 4. Method Combination Patterns

Even for a single task, efficiency can be maximized by switching methods according to the phase.

### Pattern 1: Design → Implementation → Polish

```
Method A (design discussion) → Method B (implementation) → Method C (polish)

Example: Introducing a new schema version
  1. Method A: discuss schema structure, determine field definitions
  2. Method B: implement parser/builder, create tests, generate data
  3. Method C: add docstrings, unify type annotations, fix lint
```

### Pattern 2: Theory → Computation → Cleanup

```
Method A (theory review) → Method B (computational verification) → Method C (code cleanup)

Example: Proving a new theoretical proposition
  1. Method A: discuss proof strategy, determine approach
  2. Method B: implement computation scripts, numerical verification, create proof notes
  3. Method C: refactor code, organize tests
```

### Pattern 3: Review-Driven + Method Selection

```
Review comments → Method determination → Response

Example: Multiple comments in docs/issues/issue_open.md
  - "Verify the sign of the structure constants" → Method A/B (mathematical verification)
  - "Add docstrings" → Method C (mechanical task)
  - "Add test cases" → Method B (implementation + verification)
```

### Pattern 4: Parallel Execution

```
Method B (main task) + Method C (sub-task) in parallel

Example: Large-scale refactoring
  - Method B: core logic changes (under human supervision)
  - Method C: peripheral code cleanup (submitted as parallel PRs)
  * Watch for conflicts. Merge Method B first, then update Method C PRs
```

## 5. Decision Criteria Summary

Quick decision guide when in doubt:

1. **"Does a human need to judge whether this change is correct?"** → Method A/B
2. **"Tests passing means it's correct"** → Method B/C
3. **"Can be done with pattern substitution"** → Method C
4. **"Need to decide direction while executing"** → Method B
5. **"Want to discuss thoroughly before deciding"** → Method A

The most important principle: **For tasks requiring mathematical correctness judgment, always choose a method that keeps humans in the loop.**
In research projects, code correctness often equals academic correctness.
Prioritize correctness assurance over automation convenience.
