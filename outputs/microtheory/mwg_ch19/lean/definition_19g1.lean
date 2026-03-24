import Mathlib

/-- A set A ⊂ R^S of random variables is spanned by a given asset structure
if every a ∈ A is in the range of the return matrix R, i.e., every a ∈ A
can be expressed as a linear combination of the available asset returns. -/
def AssetStructure.spannedBy
    {S K : Type*} [Fintype S] [Fintype K]
    (R : Matrix S K ℝ) (A : Set (S → ℝ)) : Prop :=
  A ⊆ Set.range R.mulVec