import Mathlib
open Topology

theorem Exercise_4_2 : ∃ (d : Fin 2 → ℝ → ℝ → ℝ)
    (w₁ w₂ w₁' w₂' : ℝ),
    (∀ i p α w, 0 < α → d i p (α * w) = α * d i p w) ∧
    (∃ p w, d 0 p w ≠ d 1 p w) ∧
    w₁ + w₂ = w₁' + w₂' ∧
    d 0 1 w₁ + d 1 1 w₂ ≠ d 0 1 w₁' + d 1 1 w₂' := by
  refine ⟨![fun _p w => w, fun _p w => w / 2], 1, 1, 0, 2, ?_, ?_, ?_, ?_⟩
  · intro i p α w hα
    fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one] <;> ring
  · exact ⟨1, 1, by simp [Matrix.cons_val_zero, Matrix.cons_val_one]⟩
  · norm_num
  · simp [Matrix.cons_val_zero, Matrix.cons_val_one]