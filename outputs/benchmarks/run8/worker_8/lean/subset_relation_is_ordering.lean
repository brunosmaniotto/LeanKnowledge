import Mathlib

variable {α : Type*}

theorem subset_is_ordering (𝕊 : Set (Set α)) : 
    IsPartialOrder (↥𝕊) (fun A B : ↥𝕊 => (A : Set α) ⊆ B) := by
  refine { refl := ?_, trans := ?_, antisymm := ?_ }
  · intro A
    exact Set.Subset.refl (A : Set α)
  · intro A B C hAB hBC
    exact Set.Subset.trans hAB hBC
  · intro A B hAB hBA
    exact Subtype.ext (Set.Subset.antisymm hAB hBA)