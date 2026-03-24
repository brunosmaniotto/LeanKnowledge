import Mathlib

namespace MWG

/-- A correspondence f : A → Set Y is upper hemicontinuous if it has a closed graph
    and the images of compact subsets of A are bounded (Definition M.H.3). -/
def IsUpperHemicontinuous
    {X : Type*} {Y : Type*}
    [TopologicalSpace X] [TopologicalSpace Y] [Bornology Y]
    (A : Set X) (f : X → Set Y) : Prop :=
  IsClosed {p : X × Y | p.1 ∈ A ∧ p.2 ∈ f p.1} ∧
  ∀ B : Set X, B ⊆ A → IsCompact B → Bornology.IsBounded (⋃ x ∈ B, f x)

end MWG