import Mathlib

open BigOperators Finset

/-- Market demand inherits homogeneity of degree zero from individual demands. -/
theorem market_demand_homogeneous_degree_zero
    {I : Type*} [Fintype I] [DecidableEq I]
    (q : I → ℝ → ℝ → ℝ → ℝ)
    (hq : ∀ i : I, ∀ p pbar yi t : ℝ, t > 0 →
      q i (t * p) (t * pbar) (t * yi) = q i p pbar yi)
    (p pbar : ℝ) (y : I → ℝ) (t : ℝ) (ht : t > 0) :
    ∑ i : I, q i (t * p) (t * pbar) (t * (y i)) = ∑ i : I, q i p pbar (y i) := by
  congr 1
  ext i
  exact hq i p pbar (y i) t ht