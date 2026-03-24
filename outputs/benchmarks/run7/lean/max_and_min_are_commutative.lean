import Mathlib

variable {α : Type _} [LinearOrder α]

theorem max_commute (x y : α) : max x y = max y x :=
  max_comm x y