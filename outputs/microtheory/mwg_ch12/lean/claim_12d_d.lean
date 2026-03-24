import Mathlib

theorem bertrand_collusion_threshold (J : ℕ) (hJ : 2 ≤ J) :
    ((↑J - 1 : ℚ) / ↑J ≥ 0) ∧
    ((↑J - 1 : ℚ) / ↑J < 1) ∧
    ((↑J - 1 : ℚ) / ↑J ≤ (↑J : ℚ) / (↑J + 1)) := by
  have hJ_pos : (0 : ℚ) < ↑J := by exact_mod_cast show 0 < J by omega
  have hJ1_pos : (0 : ℚ) < ↑J + 1 := by linarith
  have hcast : (1 : ℚ) ≤ (↑J : ℚ) := by exact_mod_cast show 1 ≤ J by omega
  have hJ_ne : (↑J : ℚ) ≠ 0 := ne_of_gt hJ_pos
  have hJ1_ne : (↑J : ℚ) + 1 ≠ 0 := ne_of_gt hJ1_pos
  refine ⟨?_, ?_, ?_⟩
  · apply div_nonneg _ (le_of_lt hJ_pos); linarith
  · rw [div_lt_one hJ_pos]; linarith
  · field_simp
    nlinarith [sq_nonneg (↑J : ℚ)]