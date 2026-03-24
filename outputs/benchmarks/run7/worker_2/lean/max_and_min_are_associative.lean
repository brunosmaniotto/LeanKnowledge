import Mathlib

theorem max_assoc_of_three {α : Type} [LinearOrder α] (x y z : α) : max (max x y) z = max x (max y z) :=
  max_assoc x y z