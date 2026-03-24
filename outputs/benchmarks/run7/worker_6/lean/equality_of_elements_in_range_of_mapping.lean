import Mathlib

open Set

variable {S T : Type _} (f : S → T) (x₁ x₂ : S)

theorem exists_common_range_iff : (∃ y ∈ range f, (x₁, y) ∈ {p | f p.1 = p.2} ∧ (x₂, y) ∈ {p | f p.1 = p.2}) ↔ f x₁ = f x₂ := by
  constructor
  · intro ⟨y, ⟨z, hz⟩, h1, h2⟩
    simp_rw [mem_setOf_eq] at h1 h2
    exact h1.trans h2.symm
  · intro h
    refine ⟨f x₂, ⟨x₂, rfl⟩, ?_, ?_⟩
    · simp [h]
    · simp