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

1. Create a new repository from this template
2. Choose your language: copy contents from `en/` or `ja/` to the project root
3. Follow [CUSTOMIZE.md](en/CUSTOMIZE.md) for project-specific setup
4. Edit `handover/ai_trust_policy.md` for your project
5. Fill in `handover/handover_memo_latest.md` with initial state
6. Start an AI session

## Directory Structure

```
├── en/                               # English documentation tree
│   ├── CUSTOMIZE.md                  # Setup guide (English)
│   ├── handover/                     # Workflow & session management
│   └── docs/                         # Issues, theory, drafts
├── ja/                               # Japanese documentation tree
│   ├── CUSTOMIZE.md                  # セットアップガイド（日本語）
│   ├── handover/                     # ワークフロー・セッション管理
│   └── docs/                         # イシュー、理論資料、草稿
├── .github/copilot-instructions.md   # Copilot project settings
├── GEMINI.md                         # Gemini CLI project settings
├── data/                             # Data files (JSON, etc.)
├── src/                              # Source code
├── tests/                            # Test code
├── experiments/                      # Experiment scripts
├── examples/                         # Sample code
├── scripts/                          # Utility scripts
└── _legacy/                          # Deprecated files archive
```

## References

- H. Aoi, *A collaborative workflow for human-AI research in pure mathematics*, Preprint, 2026.
  <!-- arXiv link: https://arxiv.org/abs/2604.YYYYY -->
- Case study repository: [osp-triviality](https://github.com/ritsumei-aoi/osp-triviality)

## License

<!-- CUSTOMIZE: Add your license information -->
