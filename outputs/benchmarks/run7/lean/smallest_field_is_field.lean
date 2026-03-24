import Mathlib
open Cardinal

theorem smallest_field_card : ∃ (F : Type) (_ : Field F), #F = 2 ∧ ∀ (K : Type) [Field K], 2 ≤ #K := by
  refine ⟨ZMod 2, inferInstance, ?_, ?_⟩
  · have h : Fintype.card (ZMod 2) = 2 := by decide
    simp [Cardinal.mk_fintype, h]
  · intro K _inst
    exact Cardinal.two_le_iff.mpr ⟨0, 1, zero_ne_one⟩