# Triviality Certificates for B(0,n)

## Overview

A **triviality certificate** for the first-order deformation of B(0,n) = osp(1|2n)
is a vector **c** ∈ F^d such that **c**^T · A = **0**, where A is the matrix
representation of the coboundary operator δ restricted to the relevant weight space.

If such a certificate exists for every weight, then H²(g, g) = 0, proving that
all first-order inhomogeneous deformations are trivial (i.e., equivalent to the
undeformed algebra via a change of basis).

## Certificate Structure

For each B(0,n), the certificates are organized by **family** according to
the weight structure:

| Family | Weight type | Description |
|--------|------------|-------------|
| I | ±δ_k | Single odd root weights |
| II | ±δ_k ± δ_l (k ≠ l) | Pairs of odd root weights |
| III | ±2δ_k | Even root weights |

### Family I and II: n-Invariance

Certificates for Families I and II satisfy an **n-invariance property**:
the certificate vector is independent of the algebra rank n (for n ≥ n₀
where n₀ is a small bound depending on the family).

This means a single certificate verified for small n proves the result
for all n ≥ n₀.

### Family III: Rank-Dependent Formula

Family III certificates depend on n through a unified formula:

```
c₂ = 1 + δ_{n,2}
```

where δ_{n,2} is the Kronecker delta. This gives c₂ = 1 for n ≠ 2
and c₂ = 2 for n = 2.

## Verification Method

Each certificate can be verified by:

1. **Algebraic check**: Compute c^T · A symbolically and confirm all entries vanish
2. **Numerical check**: Evaluate for specific n using the computed structure constants
   from `data/algebra_structures/` (JSON Schema 1) and adjoint matrices

The verification scripts in `scripts/` implement both approaches:
- `scripts/verify_certificates_algebraic.py` — symbolic verification
- `scripts/check_triviality.py` — numerical rank-based verification

## Data Pipeline

```
data/algebra_structures/B0n.json    (Schema 1: structure constants)
        ↓ compute_gamma_from_gb()
data/gamma_structures/B0n_gamma.json (Schema 2: gamma matrix)
        ↓ triviality_checker
Certificate verification (rank deficiency of coboundary matrix)
```

## References

- Bakalov–Sullivan, arXiv:1612.09400v2 (deformation framework)
- Frappat–Sciarrino–Sorba, arXiv:hep-th/9607161 (basis convention)
