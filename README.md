# AI Research Workflow Template

A template repository for AI-assisted research workflows.

AI を活用した研究ワークフローのテンプレートリポジトリ。

---

## Language / 言語

This repository provides documentation in both English and Japanese.
Choose your language below.

このリポジトリは英語・日本語の両方でドキュメントを提供しています。
以下から言語を選択してください。

| | English | 日本語 |
|---|---|---|
| **Getting Started** | [en/CUSTOMIZE.md](en/CUSTOMIZE.md) | [ja/CUSTOMIZE.md](ja/CUSTOMIZE.md) |
| **Quick Start** | [en/quickstart.md](en/quickstart.md) | [ja/quickstart.md](ja/quickstart.md) |
| **Handover Index** | [en/handover/README.md](en/handover/README.md) | [ja/handover/README.md](ja/handover/README.md) |
| **Method B (Issue-Driven Agent)** | [en/handover/workflow_method_b.md](en/handover/workflow_method_b.md) | [ja/handover/workflow_method_b.md](ja/handover/workflow_method_b.md) |
| **Common Rules** | [en/handover/workflow_common.md](en/handover/workflow_common.md) | [ja/handover/workflow_common.md](ja/handover/workflow_common.md) |
| **Method Comparison** | [en/handover/workflow_methods_comparison.md](en/handover/workflow_methods_comparison.md) | [ja/handover/workflow_methods_comparison.md](ja/handover/workflow_methods_comparison.md) |

---

## Overview

This template provides a workflow foundation for academic research projects
using AI assistants (GitHub Copilot, Gemini CLI, etc.).

### Key Features

- **Issue-driven workflow**: Structured task management via `docs/issues/`
- **AI delegation boundary policy**: Explicit definition of tasks delegable to AI
- **Session handover system**: Context preservation across AI sessions via `handover/`
- **Three workflow methods**: Method A (interactive), Method B (issue-driven agent), Method C (GitHub Agentic)

## Quick Start

> **Detailed guides with examples:** [English](en/quickstart.md) | [日本語](ja/quickstart.md)

| Method | Environment | Summary |
|--------|-------------|---------|
| **A** (Interactive) | Browser AI chat (ChatGPT, Claude, etc.) | Attach workflow files → dialog → apply changes locally |
| **B** (Agent) | AI with file access (Copilot, Gemini CLI) | Write `issue_open.md` → AI handles autonomously |
| **Z** (Bootstrap) | Any AI | Give the AI this repo URL and let it guide you |

### Minimal Setup

1. Create a new repository from this template
2. Choose your language: work within `en/` or `ja/`
3. Follow [CUSTOMIZE.md](en/CUSTOMIZE.md) for project-specific setup
4. Edit `handover/ai_trust_policy.md` for your project
5. Fill in `handover/handover_memo_latest.md` with initial state
6. Start an AI session (see the Quick Start guide for your chosen method)

## Directory Structure

```
├── en/                               # English documentation tree
│   ├── CUSTOMIZE.md                  # Setup guide (English)
│   ├── handover/                     # Workflow & session management
│   └── docs/                         # Issues, theory
├── ja/                               # Japanese documentation tree
│   ├── CUSTOMIZE.md                  # セットアップガイド（日本語）
│   ├── handover/                     # ワークフロー・セッション管理
│   └── docs/                         # イシュー、理論資料
├── samples/                          # Sample data (en/ja bilingual)
│   └── docs/                         # Example issues and theory documents
│       ├── issues/                   # Completed issue examples
│       └── theory/                   # Theory document examples
├── .github/copilot-instructions.md   # Copilot project settings
├── GEMINI.md                         # Gemini CLI project settings
├── data/                             # Data files (JSON, etc.)
├── docs/                             # Shared docs (issues, theory)
├── src/                              # Source code
└── tests/                            # Test code
```

### Language Directories (`en/`, `ja/`)

Each language directory contains a complete, self-contained documentation set.
Users copy the contents of their preferred language to the project root.
The language choice affects only the instruction language — the research content
(papers, code, data) remains the same regardless of the chosen language.

### Samples Directory

`samples/` contains example data demonstrating the workflow in practice:

- **`samples/docs/issues/`** — Completed issue examples showing the full issue lifecycle
  (proposal, research, verification, and trust boundary remand) with AI responses, in both English and Japanese.
- **`samples/docs/theory/`** — Theory document examples showing how `docs/theory/` is used
  to store mathematical background referenced by issues and verification scripts.

These samples are based on the [osp-triviality](https://github.com/ritsumei-aoi/osp-triviality)
case study.

## References

- H. Aoi, *A collaborative workflow for human-AI research in pure mathematics*, Preprint, 2026.
  \[[PDF](aoi2026_collaborative_workflow.pdf)\]
- H. Aoi, *On the triviality of inhomogeneous deformations of osp(1|2n)*, arXiv:2604.05252 [math.RT], 2026.
  \[[arXiv](https://arxiv.org/abs/2604.05252)\] \[[PDF](https://github.com/ritsumei-aoi/osp-triviality/blob/main/aoi2026_triviality_osp1_2n.pdf)\]
- Case study repository: [osp-triviality](https://github.com/ritsumei-aoi/osp-triviality)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
