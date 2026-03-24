import Mathlib

theorem complex_add_abelian_group : Nonempty (AddCommGroup ℂ) ∧ Infinite ℂ :=
  ⟨⟨inferInstance⟩, inferInstance⟩