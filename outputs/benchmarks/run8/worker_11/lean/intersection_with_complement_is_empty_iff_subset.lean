import Mathlib

theorem subset_iff_inter_compl_eq_empty {α : Type*} (S T : Set α) : S ⊆ T ↔ S ∩ Tᶜ = ∅ := by
  constructor
  · intro hST
    ext x
    constructor
    · intro hx
      exfalso
      exact hx.2 (hST hx.1)
    · intro hx
      exfalso
      exact hx
  · intro h
    intro x hxS
    by_contra hxT
    have hx : x ∈ S ∩ Tᶜ := ⟨hxS, hxT⟩
    rw [h] at hx
    exact hx.elim