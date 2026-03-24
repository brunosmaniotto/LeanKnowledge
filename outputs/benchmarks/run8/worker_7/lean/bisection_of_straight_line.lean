import Mathlib

theorem Bisection_of_Straight_Line (A B : ℝ) : ∃ D : ℝ, dist A D = dist D B ∧ D ∈ segment ℝ A B := by
  use (A + B) / 2
  constructor
  · rw [Real.dist_eq, Real.dist_eq]
    have H1 : A - (A + B) / 2 = (A - B) / 2 := by ring
    have H2 : (A + B) / 2 - B = (A - B) / 2 := by ring
    rw [H1, H2]
  · refine ⟨1/2, 1/2, by norm_num, by norm_num, by norm_num, ?_⟩
    simp [smul_eq_mul]
    ring