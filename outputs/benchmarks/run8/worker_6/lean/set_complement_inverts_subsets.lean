import Mathlib

open Set

theorem Set_Complement_inverts_Subsets {α : Type*} (S T : Set α) : S ⊆ T ↔ Tᶜ ⊆ Sᶜ := by
  constructor
  · intro hST x hx hxS
    exact hx (hST hxS)
  · intro hTcSc x hxS
    by_contra h'
    exact (hTcSc h') hxS