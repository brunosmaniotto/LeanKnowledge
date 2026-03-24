import Mathlib
open Filter

theorem divergence_test (a : ℕ → ℝ) (h : ¬Tendsto a atTop (nhds 0)) : ¬Summable a := by
  intro hsum
  have h0 : Tendsto a atTop (nhds 0) := by
    rw [← Nat.cofinite_eq_atTop]
    exact hsum.tendsto_cofinite_zero
  exact h h0