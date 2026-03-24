import Mathlib

theorem rational_numbers_under_addition_form_abelian_group :
    Nonempty (AddCommGroup ℚ) ∧ Countable ℚ ∧ Infinite ℚ := by
  exact ⟨⟨inferInstance⟩, inferInstance, inferInstance⟩