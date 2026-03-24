import Mathlib

open Real

theorem nth_root_continuous_at (n : ℕ) (hn : n ≠ 0) (ξ : ℝ) (hξ : 0 ≤ ξ) :
    ContinuousAt (fun x : ℝ => x ^ ((1 : ℝ) / (n : ℝ))) ξ := by
  have h1n : 0 ≤ (1 : ℝ) / (n : ℝ) := by
    refine div_nonneg (by norm_num) (Nat.cast_nonneg n)
  by_cases hξ0 : ξ = 0
  · subst hξ0
    exact continuousAt_id.rpow_const (Or.inr h1n)
  · exact continuousAt_id.rpow_const (Or.inl hξ0)