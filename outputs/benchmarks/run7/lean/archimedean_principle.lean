import Mathlib

theorem archimedean_principle (x : ℝ) : ∃ n : ℕ, (n : ℝ) > x := by
  exact exists_nat_gt x