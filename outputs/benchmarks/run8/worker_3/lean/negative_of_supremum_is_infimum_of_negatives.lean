import Mathlib

open Set

theorem Negative_of_Supremum_is_Infimum_of_Negatives (S : Set ℝ) (h : BddAbove S) :
    BddBelow (-S) ∧ - (sSup S) = sInf (-S) := by
  constructor
  · rwa [bddBelow_neg]
  · exact (Real.sInf_neg S).symm