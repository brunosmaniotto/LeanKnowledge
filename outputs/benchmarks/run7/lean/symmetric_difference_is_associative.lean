import Mathlib

open Set
open scoped symmDiff

theorem Symmetric_Difference_is_Associative {α : Type _} (R S T : Set α) : R ∆ (S ∆ T) = (R ∆ S) ∆ T :=
  symm (symmDiff_assoc R S T)