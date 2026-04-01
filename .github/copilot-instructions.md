Purpose

Short, actionable instructions for Copilot/GitHub AI sessions in this repository: build/test/lint commands, high-level architecture, and repository-specific conventions to make automated sessions effective.

Quick commands

- Setup (editable install):
  - pip install -e .
  - pip install -r requirements.txt
- Run regression tests:
  - pytest tests/ -v
- Run a single test:
  - pytest tests/<file>.py::test_function_name -q
  - or use substring filtering: pytest -k "substring" -q
- Validate B(m,n) structure JSON (super-Jacobi etc.):
  - python experiments/test_B_structure_json.py --m 2 --n 1
- Step 9 reverse verification (f → γ = δf):
  - python experiments/verify_f_to_gamma.py --all

Linter / formatting

- No repository-wide linter config detected (e.g. .flake8, pyproject.toml for black) — use your preferred tools (flake8/ruff/black) scoped to src/ and tests/ if desired.

High-level architecture (big picture)

- Data-driven pipeline: mathematical objects are stored as JSON under data/ and processed in four schema layers:
  - Schema 1 (data/algebra_structures/): κ=0 structure constants for B(m,n)
  - Schema 2 (data/gamma_structures/): symbolic γ structure with gh variables
  - Schema 3 (data/evaluated_structures/): gh-substituted full brackets including κ-terms
  - Schema 4 (data/coboundary_structures/): algebraic structure derived from a given odd map f (γ = δf)
- Core library (src/oscillator_lie_superalgebras):
  - B_generators.py — B(m,n) basis and structure constants (main generator source)
  - evaluated_structure_builder.py / evaluated_structure_parser.py — Schema 3 build and parse
  - coboundary_structure_builder.py — Schema 4 build (FMapEncoder + CoboundaryStructureBuilder)
  - cohomology_solver.py — solve_odd_f_generic (γ→f) and reconstruct_gamma_from_f (f→γ)
  - adjoint_from_json.py — adjoint representation matrices from JSON
  - gamma_parser.py / algebra_parser.py — JSON parsing utilities
- Key experiment scripts: check_triviality_from_json.py (triviality pipeline), verify_f_to_gamma.py (Step 9 reverse check), generate_coboundary_structure.py (Schema 4 generation)
- Triviality results are persisted in data/triviality_results.csv (primary key: json_filename).
- Handover & AI workflow: handover/ contains session notes and the unified Method B workflow (handover/workflow_method_b.md) for automated agents.

Key repository-specific conventions

- JSON schema and file naming (v5.0 conventions):
  - Schema 3: {Type}_{m}_{n}_gh_{flat}.json (e.g. B_0_1_gh_0_m1.json)
  - Schema 4: {Type}_{m}_{n}_f_{flat_f}.json (e.g. B_0_1_f_0_m2o7_....json)
  - Negative numbers: "m" prefix; decimals: "p"; sqrt(2): "r2"; fractions p/q: "po q" → "{p}o{q}" (o = over)
- PBW (Poincaré–Birkhoff–Witt) ordering for generators (v5.0):
  - kappa (odd central, rank 0) → a_0 → a_j_p → a_j_m (j ascending) → b_i_p → b_i_m (i ascending) → K (even central, last)
  - This ordering is used consistently in gh matrix row/column ordering and JSON encodings.
- gh sign conventions (v5.0):
  - gh_v5 differs from earlier v4.1 by a sign flip and basis reorder; consult handover/handover_memo_latest.md when comparing with paper values.
- kappa (κ) parity handling:
  - κ is defined with commutative=True in OscillatorRewriterV5 but is logically odd (p(κ)=1). When moving κ past odd generators, code applies sign corrections based on the count of preceding odd elements. Automated sessions must preserve this behavior.
- evaluated_brackets JSON:
  - Keys: "evaluated_brackets" → contains "kappa_symbol" and a mapping of "X,Y" → {"Z":"coeff_str"}. Terms containing kappa (e.g. "kappa", "2*kappa") represent γ coefficients; terms without kappa are structure constants.
- Symbol parsing: use sympy.sympify / sp.Symbol objects when constructing Polys; passing raw strings for polynomial symbols may cause incorrect parsing.

AI agent rules & integration notes

- Read these files at session start (in this order):
  1) handover/README.md
  2) handover/workflow_common.md
  3) handover/workflow_method_b.md
  4) handover/handover_memo_latest.md
  5) handover/code_structure.md
  6) handover/notation.md (if present)
- Method selection:
  - AI agents with direct execution (Copilot Chat / Gemini CLI): use Method B (handover/workflow_method_b.md)
  - Interactive dialog without direct execution: use Method A (handover/workflow_method_a.md)
- Keep changes surgical and run tests after edits.

Where to look next

- docs/json_schema_specification.md (Schema 1/2)
- docs/json_schema_evaluated_structure.md (Schema 3)
- docs/json_schema_coboundary_structure.md (Schema 4)
- handover/* for session-specific notes and workflows
- experiments/ for example scripts that generate and validate JSON artifacts

If there are existing AI assistant configs

- This repository uses handover/workflow_method_b.md as the unified AI agent workflow (Method B).
  No CLAUDE.md, AGENTS.md, or .cursorrules files are used.

