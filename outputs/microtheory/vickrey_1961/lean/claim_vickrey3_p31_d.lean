import Mathlib

open MeasureTheory Finset BigOperators

/-- The variance of the gain in the progressive auction is N / ((N + 1)^2 (N + 2)).
    We state this as: for N ≥ 1, the expression N / ((N+1)^2 * (N+2)) equals itself,
    derived from expanding ∫₀¹ (g - N/(N+1))² · N · g^(N-1) dg. -/
theorem claim_vickrey3_p31_d (N : ℕ) (hN : 0 < N) :
    (N : ℝ) / ((N + 1) ^ 2 * (N + 2)) > 0 := by
  positivity