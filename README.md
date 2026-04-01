# AI Research Workflow Template

AI を活用した研究ワークフローのテンプレートリポジトリ。

## 概要

このテンプレートは、AI アシスタント（GitHub Copilot, Gemini CLI 等）を活用した学術研究プロジェクトのワークフロー基盤を提供します。

### 主な機能

- **セッション引き継ぎシステム**: `handover/` による AI セッション間の文脈保持
- **3 つのワークフロー方式**: Method A（対話型）、Method B（エージェント型）、Method C（GitHub Agentic）
- **レビュー駆動ワークフロー**: `docs/reviews/` によるレビュー指摘の構造化管理
- **プロンプトキット**: `handover/next_session/` によるセッション開始・終了の標準化

## クイックスタート

1. このテンプレートから新しいリポジトリを作成
2. `CUSTOMIZE.md` の手順に従ってプロジェクト固有の設定を行う
3. `handover/handover_memo_latest.md` に初期状態を記入
4. AI セッションを開始

## ディレクトリ構成

```
├── .github/copilot-instructions.md   # Copilot 用プロジェクト設定
├── GEMINI.md                         # Gemini CLI 用プロジェクト設定
├── CUSTOMIZE.md                      # カスタマイズ手順書
├── handover/                         # セッション引き継ぎ・ワークフロー定義
│   ├── README.md                     # 引き継ぎ情報の索引
│   ├── workflow_common.md            # 全方式共通ルール
│   ├── workflow_method_a.md          # Method A（対話型）
│   ├── workflow_method_b.md          # Method B（エージェント型）
│   ├── workflow_method_c.md          # Method C（GitHub Agentic）[Draft]
│   ├── workflow_review.md            # レビュー駆動ワークフロー
│   ├── workflow_methods_comparison.md # 方式比較ガイド
│   ├── handover_memo_latest.md       # 最新セッション引き継ぎ
│   ├── handover_memo_archived.md     # 過去セッション履歴
│   ├── handover_memo_format.md       # メモ形式定義
│   ├── session_protocol_method_a.md  # Method A 詳細手順
│   └── next_session/                 # 次回セッション用プロンプトキット
├── docs/
│   ├── reviews/                      # レビュー管理
│   ├── theory/                       # 理論資料
│   └── drafts/                       # 論文草稿（LaTeX）
├── data/                             # データファイル（JSON 等）
├── src/                              # ソースコード
├── tests/                            # テストコード
├── experiments/                      # 実験スクリプト
├── examples/                         # サンプルコード
├── scripts/                          # ユーティリティスクリプト
├── log/                              # セッションログ
└── _legacy/                          # 非推奨ファイルの保管場所
```

## カスタマイズ

`CUSTOMIZE.md` を参照してください。`<!-- CUSTOMIZE -->` マーカーが付いたファイルをプロジェクトに合わせて編集します。

## ワークフロー詳細

- [handover/README.md](handover/README.md) — 全文書の索引と推奨読了順
- [handover/workflow_common.md](handover/workflow_common.md) — 全方式共通ルール
- [handover/workflow_methods_comparison.md](handover/workflow_methods_comparison.md) — 方式の比較と選択ガイド

## ライセンス

<!-- CUSTOMIZE: Add your license information -->
