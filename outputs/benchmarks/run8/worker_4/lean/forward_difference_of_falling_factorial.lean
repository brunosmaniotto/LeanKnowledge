import Mathlib

noncomputable def falling (x : ℝ) (m : ℕ) : ℝ := ∏ k ∈ Finset.range m, (x - (k : ℝ))

lemma falling_succ (x : ℝ) (m : ℕ) : falling x (m + 1) = falling x m * (x - m) := by
  simp [falling, Finset.prod_range_succ]