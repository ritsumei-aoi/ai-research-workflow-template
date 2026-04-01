# Purpose

Short, actionable instructions for Copilot/GitHub AI sessions in this repository: build/test/lint commands, high-level architecture, and repository-specific conventions to make automated sessions effective.

# Quick commands

- Setup (editable install):
  - pip install -e .
  - pip install -r requirements.txt
- Run regression tests:
  - pytest tests/ -v
- Run a single test:
  - pytest tests/<file>.py::test_function_name -q
  - or use substring filtering: pytest -k "substring" -q
<!-- CUSTOMIZE: Add project-specific commands here -->

# Linter / formatting

- No repository-wide linter config detected (e.g. .flake8, pyproject.toml for black) — use your preferred tools (flake8/ruff/black) scoped to src/ and tests/ if desired.

# High-level architecture (big picture)

<!-- CUSTOMIZE: Describe your project's architecture here. Example:
- Data-driven pipeline: mathematical objects are stored as JSON under data/ and processed by scripts.
- Core library (src/your_package): main computation modules.
- Experiment scripts (experiments/): scripts for running experiments and validating results.
-->

# Key repository-specific conventions

<!-- CUSTOMIZE: Describe your project's conventions here. Example:
- JSON schema and file naming conventions.
- Symbol and notation conventions.
- Data format specifications.
-->

# AI agent rules & integration notes

- Read these files at session start (in this order):
  1) handover/README.md
  2) handover/workflow_common.md
  3) handover/workflow_method_b.md
  4) handover/handover_memo_latest.md
  <!-- CUSTOMIZE: Add project-specific files to the reading order, e.g.:
  5) handover/code_structure.md
  6) handover/notation.md
  -->
- Method selection:
  - AI agents with direct execution (Copilot Chat / Gemini CLI): use Method B (handover/workflow_method_b.md)
  - Interactive dialog without direct execution: use Method A (handover/workflow_method_a.md)
- Keep changes surgical and run tests after edits.

# Where to look next

- handover/* for session-specific notes and workflows
- docs/ for project documentation
<!-- CUSTOMIZE: Add project-specific documentation references here -->

# If there are existing AI assistant configs

- This repository uses handover/workflow_method_b.md as the unified AI agent workflow (Method B).
  No CLAUDE.md, AGENTS.md, or .cursorrules files are used.

