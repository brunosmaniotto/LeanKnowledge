import Mathlib

-- Proved sub-lemma from the prompt.
-- This is used to satisfy the `n ≠ 0` condition required for `n.factorization`.
lemma n_ge_2_implies_ne_zero (n : ℕ) (hn : n ≥ 2) : n ≠ 0 := by
  -- The hypothesis `n ≥ 2` and the assumption `n = 0` (from trying to prove `n ≠ 0`
  -- by contradiction) are a direct contradiction in linear arithmetic.
  -- `linarith` can solve this automatically.
  linarith

-- Main theorem: Tau Function from Prime Decomposition
-- Let n be an integer such that n ≥ 2.
-- Let the prime decomposition of n be n = p₁^k₁ * p₂^k₂ * ⋯ * pᵣ^kᵣ.
-- Let τ(n) be the tau function of n (number of positive divisors).
-- Then τ(n) = (k₁ + 1) * (k₂ + 1) * ⋯ * (kᵣ + 1).
-- In Lean, this is expressed using `n.factorization`, where `n.factorization p` is the exponent `k` for a prime `p`.