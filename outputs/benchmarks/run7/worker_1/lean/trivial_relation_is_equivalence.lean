import Mathlib

theorem trivial_relation_is_equivalence (α : Type*) (S : Set α) :
    Equivalence (λ (x y : S) => ((x : α), (y : α)) ∈ S ×ˢ S) := by
  refine {
    refl := fun x => ⟨x.property, x.property⟩
    symm := fun h => ⟨h.2, h.1⟩
    trans := fun h1 h2 => ⟨h1.1, h2.2⟩ }