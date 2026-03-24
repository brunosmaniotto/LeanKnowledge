import Mathlib

open Finset BigOperators
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I]

theorem Example_18AA8
    (v : Finset I → ℝ)
    (h_supermod : ∀ (A B : Finset I),
      v (A ∩ B) + v (A ∪ B) ≥ v A + v B)
    : ∀ (S T : Finset I), S ⊆ T →
      ∀ i : I, i ∉ T →
      v (S ∪ {i}) - v S ≤ v (T ∪ {i}) - v T := by
  intro S T hST i hi
  have hinter : (S ∪ {i}) ∩ T = S := by
    ext x
    simp only [mem_inter, mem_union, mem_singleton]
    constructor
    · rintro ⟨hxS | rfl, hxT⟩
      · exact hxS
      · exact absurd hxT hi
    · intro hx
      exact ⟨Or.inl hx, hST hx⟩
  have hunion : (S ∪ {i}) ∪ T = T ∪ {i} := by
    ext x
    simp only [mem_union, mem_singleton]
    tauto
  have h := h_supermod (S ∪ {i}) T
  rw [hinter, hunion] at h
  linarith