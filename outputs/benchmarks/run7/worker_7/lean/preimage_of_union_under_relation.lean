import Mathlib

variable {S T : Type} (R : Set (S × T)) (T₁ T₂ : Set T)

theorem preimage_union : {x | ∃ y ∈ T₁ ∪ T₂, (x, y) ∈ R} = {x | ∃ y ∈ T₁, (x, y) ∈ R} ∪ {x | ∃ y ∈ T₂, (x, y) ∈ R} := by
  ext x
  constructor
  · intro h
    rcases h with ⟨y, hy, hxy⟩
    cases hy with
    | inl hy1 => left; exact ⟨y, hy1, hxy⟩
    | inr hy2 => right; exact ⟨y, hy2, hxy⟩
  · intro h
    cases h with
    | inl h1 =>
        rcases h1 with ⟨y, hy, hxy⟩
        exact ⟨y, Or.inl hy, hxy⟩
    | inr h2 =>
        rcases h2 with ⟨y, hy, hxy⟩
        exact ⟨y, Or.inr hy, hxy⟩