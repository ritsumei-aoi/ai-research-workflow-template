# ワークフロー方式比較ガイド (Methods A / B / C)

本ドキュメントは、AI 支援ワークフローの 3 方式を比較し、
タスクに応じた方式選択の指針を提供する。

各方式の詳細:
- [workflow_method_a.md](workflow_method_a.md)（Method A: 対話型）
- [workflow_method_b.md](workflow_method_b.md)（Method B: AI エージェント型）
- [workflow_method_c.md](workflow_method_c.md)（Method C: GitHub Agentic Workflow）**[Draft]**
- [workflow_common.md](workflow_common.md)（全方式共通ルール）
- [workflow_review.md](workflow_review.md)（レビュー駆動ワークフロー — 全方式共通）

## 1. 方式比較テーブル

| 観点 | Method A（対話型） | Method B（エージェント型） | Method C（GitHub Agentic） |
|---|---|---|---|
| **インタラクション** | 人間と AI の対話ループ | AI が自律実行、人間が監視 | Issue → 自動 PR → レビュー |
| **人間の関与** | 常時（全ステップ） | 監視＋要所で承認 | Issue 作成＋PR レビュー |
| **AI のファイルアクセス** | 読み取り専用 | 完全（読み書き実行） | PR スコープ（リポジトリ全体） |
| **適したタスク** | 理論検討、設計議論、証明構成 | 実装、検証、ドキュメント整備 | リファクタリング、定型メンテナンス |
| **コンテキスト持続** | セッション内（チャット履歴） | セッション内（handover 経由で引き継ぎ） | なし（Issue 記述のみ） |
| **Git ワークフロー** | `ai/<date>-<topic>` → squash merge | `ai/<date>-<topic>` → squash merge | `agentic/<issue>-<topic>` → squash merge |
| **ツール要件** | ブラウザ / チャット UI | Copilot CLI / Gemini CLI 等 | GitHub Agentic Workflow |
| **セッション記録** | handover_memo + log/ | handover_memo + log/ | Issue / PR のみ |
| **即時フィードバック** | ◎（リアルタイム対話） | ○（実行結果を逐次確認） | △（PR 完成後にレビュー） |
| **数学的正しさの担保** | ◎（人間が逐次検証） | ○（テスト＋人間の監視） | △（テスト依存、レビュー必須） |

## 2. 方式選択フローチャート

```
タスクを実行したい
│
├─ 数学的な理論検討・証明が必要？
│   ├─ Yes → 人間の深い関与が必要
│   │         ├─ AI が直接実行できる環境？
│   │         │   ├─ Yes → Method B（検証のみモード活用）
│   │         │   └─ No  → Method A
│   │         └─ 新規証明の構成？
│   │             └─ Yes → Method A（対話で段階的に構築）
│   │
│   └─ No → 実装・メンテナンスタスク
│           │
│           ├─ タスクは機械的に定義できる？
│           │   （テスト通過で正しさを判断できる）
│           │   ├─ Yes → タスクの規模は？
│           │   │         ├─ 小〜中（単一目的） → Method C
│           │   │         └─ 大（複数ステップ）  → Method B
│           │   │
│           │   └─ No → 実行中の判断が必要
│           │           ├─ AI が直接実行できる環境？
│           │           │   ├─ Yes → Method B
│           │           │   └─ No  → Method A
│           │           └─ schema_version 変更を伴う？
│           │               └─ Yes → Method A で設計 → Method B で実装
│           │
│           └─ ドキュメントのみの変更？
│               ├─ 定型（docstring, README） → Method C
│               └─ 理論ドキュメント → Method A/B
```

## 3. 具体的なタスク別ガイド

<!-- CUSTOMIZE: Add project-specific task examples for each method. -->
<!-- Below are generic examples. Replace with your project's actual tasks. -->

### Method A を使うべきタスク

| タスク例 | 理由 |
|---|---|
| 数学的理論の検証・証明構成 | 証明の各ステップで人間の判断が不可欠 |
| スキーマ設計の意思決定 | 広範な影響があり、対話で合意形成が必要 |
| 記法・規約の変更 | 全体に波及するため、慎重な議論が必要 |

### Method B を使うべきタスク

| タスク例 | 理由 |
|---|---|
| 新しいモジュールの実装 | コード生成＋テスト実行を一貫して実施 |
| 計算的検証スクリプトの開発 | 実行結果を即座に確認しながら開発 |
| テストの追加・修正 | 既存テストとの整合性を確認しながら追加 |
| handover ドキュメントの更新 | セッションコンテキストに基づく更新 |

### Method C を使うべきタスク（導入後）

| タスク例 | 理由 |
|---|---|
| 型アノテーションの一括追加 | 機械的な変更、テストで検証可能 |
| docstring の追加・フォーマット統一 | テンプレート的な作業 |
| GitHub Actions ワークフローの追加 | CI/CD は独立して検証可能 |
| lint 警告の修正 | 機械的な修正 |

## 4. 方式の組み合わせパターン

単一のタスクでも、フェーズに応じて方式を切り替えることで効率を最大化できる。

### パターン 1: 設計→実装→仕上げ

```
Method A（設計議論）→ Method B（実装）→ Method C（仕上げ）

例: 新しい Schema バージョンの導入
  1. Method A: スキーマ構造の設計議論、フィールド定義の決定
  2. Method B: パーサー・ビルダーの実装、テスト作成、データ生成
  3. Method C: docstring 追加、型アノテーション統一、lint 修正
```

### パターン 2: 理論→計算→整備

```
Method A（理論検討）→ Method B（計算的検証）→ Method C（コード整備）

例: 新しい理論的命題の証明
  1. Method A: 証明戦略の議論、方針決定
  2. Method B: 計算スクリプト実装、数値検証、証明ノート作成
  3. Method C: コードのリファクタリング、テスト整備
```

### パターン 3: レビュー駆動＋方式選択

```
レビュー指摘 → 方式判定 → 対応

例: docs/reviews/review_open.md に複数の指摘
  - 「構造定数の符号を確認せよ」→ Method A/B（数学的検証）
  - 「docstring を追加せよ」→ Method C（機械的タスク）
  - 「テストケースを追加せよ」→ Method B（実装＋検証）
```

### パターン 4: 並行実行

```
Method B（メインタスク）＋ Method C（サブタスク）並行

例: 大規模リファクタリング
  - Method B: 核となるロジック変更（人間の監視下）
  - Method C: 周辺コードの整備（PR として並行投入）
  ※ コンフリクトに注意。Method B を先にマージしてから Method C の PR を更新
```

## 5. 方式選択の判断基準まとめ

迷った場合の簡易判定:

1. **「この変更は数学的に正しいか」を人間が判断する必要がある** → Method A/B
2. **「テストが通れば正しい」と言える** → Method B/C
3. **「パターン置換で済む」** → Method C
4. **「実行しながら方向を決めたい」** → Method B
5. **「じっくり議論してから決めたい」** → Method A

最も重要な原則: **数学的正しさの判断が必要なタスクは、必ず人間がループに入る方式を選ぶ。**
研究プロジェクトでは、コードの正しさ＝学術的正しさである場面が多い。
自動化の利便性よりも、正しさの保証を優先すること。
