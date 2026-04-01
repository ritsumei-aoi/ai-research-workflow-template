# docs/theory/ — 理論資料

振動子 Lie 超代数の変形理論に関する数学的文書をまとめるディレクトリ。

## ディレクトリ構成

```
docs/theory/
├── README.md                              # 本ファイル
├── draft_sec4_oscillator_triviality.md    # 論文 §4 草稿（メイン理論文書）
├── proof_strategy_general_Bmn.md          # 一般 B(m,n) の証明方針
├── proofs/                                # 形式的証明
│   ├── proof_n_invariance.md              # n 不変性の証明
│   ├── proof_dim_formula.md               # dim(C¹_μ) = 6n−2 の証明
│   └── proof_family3_formal.md            # Family III certificate の形式的証明
├── analysis/                              # 計算的解析・探索結果
│   ├── phase1_ker_delta_analysis.md       # Phase 1: ker(δ) の重み分解解析
│   ├── phase2_left_nullspace_analysis.md  # Phase 2: 左零空間 certificate 発見
│   ├── phase3_algebraic_proof.md          # Phase 3: certificate の代数的検証
│   ├── phase123_summary.md               # Phase 1–3 統合まとめ
│   └── triviality_report.md              # triviality 判定結果の集計
└── derivations/                           # 個別の数学的導出ノート
    ├── B_generators_derivation.md         # B(m,n) 生成元の導出
    └── normal_order_symmetric.md          # PBW 標準順序と論文記法の変換
```

## ファイル分類

### メイン文書（トップレベル）

| ファイル | 内容 |
|---|---|
| `draft_sec4_oscillator_triviality.md` | 論文 §4 草稿: B(0,n) の自明性証明（LaTeX 文書 `docs/drafts/triviality_B0n_ja.tex` と同期） |
| `proof_strategy_general_Bmn.md` | 一般 B(m,n) の triviality 証明方針（5 方針 + 数値データ） |

### proofs/ — 形式的証明

理論的に完結した証明文書。LaTeX 文書の各定理に対応する。

| ファイル | 対応する LaTeX | 内容 |
|---|---|---|
| `proof_n_invariance.md` | Theorem 3.5 | Family I/II の j-th スロット不変性 |
| `proof_dim_formula.md` | Proposition 2.1 | dim(C¹_μ) = 6n−2（ルートカウント） |
| `proof_family3_formal.md` | Proposition 3.8 | Family III: c₂ = 1+δ_{n,2} の統一公式 |

### analysis/ — 計算的解析

Python による計算的探索・検証の記録。証明の発見過程を文書化。

| ファイル | 内容 |
|---|---|
| `phase1_ker_delta_analysis.md` | ker(δ) の重み分解と次元解析（B(0,n) 限定） |
| `phase2_left_nullspace_analysis.md` | 左零空間の certificate 発見（Farkas 的手法） |
| `phase3_algebraic_proof.md` | certificate の c^T A = 0 展開による代数的検証 |
| `phase123_summary.md` | Phase 1–3 の統合まとめ（判明事実・予想・不明点） |
| `triviality_report.md` | triviality 判定結果の集計レポート |

## 関連ファイル

- `docs/drafts/triviality_B0n_ja.tex`: LaTeX 文書（日本語版、主要成果物）
- `docs/drafts/triviality_B0n_en.tex`: LaTeX 文書（英語版）
- `handover/algebraic_proof_basis.md`: 代数的証明の基礎（ランク判定基準・体拡大定理）
- `handover/notation.md`: 記法・用語の統一ルール
