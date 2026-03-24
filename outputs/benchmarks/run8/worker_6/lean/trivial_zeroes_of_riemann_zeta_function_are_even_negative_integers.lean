import Mathlib

open Complex

/-- The Riemann zeta function vanishes at negative even integers: ζ(-2k) = 0 for k ∈ ℕ, k ≥ 1.
    This covers the trivial zeros -2, -4, -6, ... -/
theorem riemannZeta_trivial_zeros (k : ℕ) : riemannZeta (-2 * (k + 1 : ℂ)) = 0 :=
  riemannZeta_neg_two_mul_nat_add_one k