import Mathlib

theorem RealNumbersUnderAdditionFormAbelianGroup : Nonempty (AddCommGroup ℝ) ∧ Infinite ℝ := by
  exact ⟨⟨inferInstance⟩, inferInstance⟩