import Mathlib

variable {S : Type} [Semigroup S] (X : Set S) (hX : X.Nonempty)

theorem exists_unique_subsemigroup_generated_by :
    ∃! T : Subsemigroup S, X ⊆ T ∧ ∀ U : Subsemigroup S, X ⊆ U → T ≤ U := by
  use Subsemigroup.closure X
  constructor
  · exact ⟨Subsemigroup.subset_closure, fun U hU => Subsemigroup.closure_le.2 hU⟩
  · intro T ⟨hT1, hT2⟩
    apply le_antisymm
    · exact hT2 (Subsemigroup.closure X) Subsemigroup.subset_closure
    · exact Subsemigroup.closure_le.2 hT1