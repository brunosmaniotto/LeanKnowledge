import Mathlib

theorem Claim_13B_t :
    ∃ (uA uB : Fin 2 → ℝ) (p : Fin 2 → ℝ),
      (∀ i, 0 < p i) ∧
      (p 0 + p 1 = 1) ∧
      (p 0 * uA 0 + p 1 * uA 1 > p 0 * uB 0 + p 1 * uB 1) ∧
      (uB 0 > uA 0) := by
  refine ⟨![1, 4], ![2, 1], ![1/2, 1/2], ?_, ?_, ?_, ?_⟩
  · intro i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one] <;> norm_num
  · simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  · simp [Matrix.cons_val_zero, Matrix.cons_val_one]; norm_num
  · simp [Matrix.cons_val_zero, Matrix.cons_val_one]; norm_num