import Mathlib

open Set

theorem complement_complement_eq_self {α : Type*} (S : Set α) : Sᶜᶜ = S := by
  ext x
  constructor
  · intro hx
    -- x ∈ Sᶜᶜ means x ∉ Sᶜ, which means ¬(x ∉ S), so x ∈ S
    simp only [mem_compl_iff] at hx
    exact not_not.mp hx
  · intro hx
    -- x ∈ S means ¬(x ∉ S), so x ∉ Sᶜ, which means x ∈ Sᶜᶜ
    simp only [mem_compl_iff]
    exact not_not.mpr hx