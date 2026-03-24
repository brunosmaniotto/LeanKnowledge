import Mathlib

theorem mod_add_has_inverse (m x : ℤ) : ∃ y : ℤ, (x + y) ≡ 0 [ZMOD m] ∧ (y + x) ≡ 0 [ZMOD m] :=
  ⟨-x, by simp, by simp⟩