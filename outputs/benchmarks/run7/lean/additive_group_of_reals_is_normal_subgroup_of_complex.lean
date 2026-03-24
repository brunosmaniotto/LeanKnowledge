import Mathlib

open Complex

/-- The additive subgroup of ℂ consisting of real numbers (with zero imaginary part) is normal. -/
theorem Real.isNormalSubgroup_of_Complex : AddSubgroup.Normal (reAddSubgroup : AddSubgroup ℂ) :=
  inferInstance