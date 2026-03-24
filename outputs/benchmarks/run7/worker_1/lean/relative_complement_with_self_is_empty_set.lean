import Mathlib

theorem relative_complement_self_eq_empty {α : Type*} (S : Set α) : S \ S = ∅ :=
  Set.diff_self (s := S)