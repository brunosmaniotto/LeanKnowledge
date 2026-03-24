import Mathlib

open Set Real

theorem Exercise_4_15_a :
    StrictAntiOn (fun p : ℝ => 1 / p ^ 2) (Ioi 0) ∧
    (∀ p l : ℝ, p ≠ 0 → l ≠ 0 →
      1 / (l * p) ^ 2 = 1 / l ^ 2 * (1 / p ^ 2)) ∧
    StrictAntiOn (fun p : ℝ => 1 / sqrt p) (Ioi 0) := by
  refine ⟨?_, ?_, ?_⟩
  · intro p₁ hp₁ p₂ hp₂ hlt
    have h1 : (0 : ℝ) < p₁ := mem_Ioi.mp hp₁
    have h2 : (0 : ℝ) < p₂ := mem_Ioi.mp hp₂
    show 1 / p₂ ^ 2 < 1 / p₁ ^ 2
    have hp1sq : (0 : ℝ) < p₁ ^ 2 := by positivity
    have hp2sq : (0 : ℝ) < p₂ ^ 2 := by positivity
    have h_sq_lt : p₁ ^ 2 < p₂ ^ 2 := by nlinarith
    suffices 0 < 1 / p₁ ^ 2 - 1 / p₂ ^ 2 by linarith
    rw [div_sub_div 1 1 hp1sq.ne' hp2sq.ne']
    exact div_pos (by linarith) (by positivity)
  · intro p l hp hl; field_simp
  · intro p₁ hp₁ p₂ hp₂ hlt
    have h1 : (0 : ℝ) < p₁ := mem_Ioi.mp hp₁
    have h2 : (0 : ℝ) < p₂ := mem_Ioi.mp hp₂
    show 1 / sqrt p₂ < 1 / sqrt p₁
    have hsq1 : (0 : ℝ) < sqrt p₁ := sqrt_pos_of_pos h1
    have hsq2 : (0 : ℝ) < sqrt p₂ := sqrt_pos_of_pos h2
    have hlt_sq : sqrt p₁ < sqrt p₂ := sqrt_lt_sqrt (le_of_lt h1) hlt
    suffices 0 < 1 / sqrt p₁ - 1 / sqrt p₂ by linarith
    rw [div_sub_div 1 1 hsq1.ne' hsq2.ne']
    exact div_pos (by linarith) (mul_pos hsq1 hsq2)