import Mathlib

theorem not_cyclic_prod_of_infinite_cyclic : ¬ IsAddCyclic (ℤ × ℤ) :=
  not_isAddCyclic_prod_of_infinite_nontrivial (M := ℤ) (N := ℤ)