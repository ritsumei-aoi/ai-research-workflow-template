# B(0,n) の自明性 certificate

## 概要

B(0,n) = osp(1|2n) の一次変形に対する **自明性 certificate** とは、
ベクトル **c** ∈ F^d であって **c**^T · A = **0** を満たすものである。
ここで A はコバウンダリ作用素 δ を該当するウェイト空間に制限した行列表現である。

すべてのウェイトについてこのような certificate が存在すれば H²(g, g) = 0 となり、
すべての一次非斉次変形が自明（基底変換により非変形代数と同値）であることが証明される。

## Certificate の構造

各 B(0,n) について、certificate はウェイト構造に従い **ファミリー** に分類される:

| ファミリー | ウェイトの型 | 説明 |
|-----------|------------|------|
| I | ±δ_k | 単一奇ルートウェイト |
| II | ±δ_k ± δ_l (k ≠ l) | 奇ルートウェイトの対 |
| III | ±2δ_k | 偶ルートウェイト |

### Family I・II: n 不変性

Family I・II の certificate は **n 不変性** を満たす:
certificate ベクトルは代数のランク n に依存しない
（n ≥ n₀ において。n₀ はファミリーに依存する小さい定数）。

これにより、小さい n で検証した単一の certificate が
すべての n ≥ n₀ に対する結果を証明する。

### Family III: ランク依存公式

Family III の certificate は統一公式を通じて n に依存する:

```
c₂ = 1 + δ_{n,2}
```

ここで δ_{n,2} は Kronecker のデルタ。n ≠ 2 のとき c₂ = 1、
n = 2 のとき c₂ = 2 となる。

## 検証方法

各 certificate は以下により検証可能:

1. **代数的検証**: c^T · A を記号的に計算し、全成分が消えることを確認
2. **数値的検証**: `data/algebra_structures/`（JSON Schema 1）の構造定数と随伴行列を用い、特定の n で評価

`scripts/` 内の検証スクリプトが両方のアプローチを実装:
- `scripts/verify_certificates_algebraic.py` — 記号的検証
- `scripts/check_triviality.py` — 数値的ランクベース検証

## データパイプライン

```
data/algebra_structures/B0n.json    (Schema 1: 構造定数)
        ↓ compute_gamma_from_gb()
data/gamma_structures/B0n_gamma.json (Schema 2: gamma 行列)
        ↓ triviality_checker
Certificate 検証（コバウンダリ行列のランク不足性）
```

## 参考文献

- Bakalov–Sullivan, arXiv:1612.09400v2（変形の枠組み）
- Frappat–Sciarrino–Sorba, arXiv:hep-th/9607161（基底の規約）
