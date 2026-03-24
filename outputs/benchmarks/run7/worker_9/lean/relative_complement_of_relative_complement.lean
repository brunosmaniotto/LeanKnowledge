import Mathlib

variable {α : Type} {S T : Set α}

theorem relative_complement_of_relative_complement (h : T ⊆ S) : S \ (S \ T) = T :=
  Set.diff_diff_cancel_left h