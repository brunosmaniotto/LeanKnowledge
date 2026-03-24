import Mathlib

theorem mod_add_identity (m x : ℤ) : x + 0 ≡ x [ZMOD m] ∧ x ≡ 0 + x [ZMOD m] := by
  simp