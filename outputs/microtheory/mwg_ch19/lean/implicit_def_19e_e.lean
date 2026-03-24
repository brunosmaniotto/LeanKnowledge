import Mathlib

/-- The range of the return matrix R: the set of wealth vectors v ∈ R^S
    that can be spanned by existing assets, i.e., v = Rz for some portfolio z ∈ R^K. -/
def returnMatrixRange {S K : Type*} [Fintype S] [Fintype K] [DecidableEq S] [DecidableEq K]
    (R : Matrix S K ℝ) : Set (S → ℝ) :=
  {v | ∃ z : K → ℝ, R.mulVec z = v}