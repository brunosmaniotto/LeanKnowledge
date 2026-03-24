import Mathlib

@[ext]
structure Relation (α : Type u) (β : Type v) where
  domain : Set α
  codomain : Set β
  graph : Set (α × β)

theorem Relation.eq_iff (R₁ R₂ : Relation α β) :
    R₁ = R₂ ↔ R₁.domain = R₂.domain ∧ R₁.codomain = R₂.codomain ∧
      (∀ (s : α) (t : β), (s, t) ∈ R₁.graph ↔ (s, t) ∈ R₂.graph) := by
  constructor
  · intro h
    subst h
    simp
  · intro ⟨h_dom, h_codom, h_graph⟩
    ext x
    · rw [h_dom]
    · rw [h_codom]
    · cases x with
      | mk s t => exact h_graph s t