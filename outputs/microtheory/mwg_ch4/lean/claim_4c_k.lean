import Mathlib
open BigOperators

theorem aggregate_ULD_not_requires_individual_ULD :
    ∃ (p p' : Fin 2 → ℝ) (x₁ x₂ y₁ y₂ : Fin 2 → ℝ),
      (∑ i : Fin 2, (p' i - p i) * (y₁ i - x₁ i) > 0) ∧
      (∑ i : Fin 2, (p' i - p i) * ((y₁ i + y₂ i) - (x₁ i + x₂ i)) ≤ 0) := by
  refine ⟨![1, 0], ![2, 0], ![0, 0], ![0, 0], ![1, 0], ![-3, 0], ?_, ?_⟩
  · show ∑ i : Fin 2, (![2, 0] i - ![1, 0] i) * (![1, 0] i - ![0, 0] i) > 0
    simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    norm_num
  · show ∑ i : Fin 2, (![2, 0] i - ![1, 0] i) * ((![1, 0] i + ![-3, 0] i) - (![0, 0] i + ![0, 0] i)) ≤ 0
    simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    norm_num