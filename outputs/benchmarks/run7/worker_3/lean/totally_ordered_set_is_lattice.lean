import Mathlib

/-- A linearly ordered set is a lattice. -/
instance {α : Type*} [LinearOrder α] : Lattice α :=
  { LinearOrder.toPartialOrder with
    inf := min
    sup := max
    inf_le_left := fun a b => min_le_left a b
    inf_le_right := fun a b => min_le_right a b
    le_inf := fun a b c hab hac => le_min hab hac
    le_sup_left := fun a b => le_max_left a b
    le_sup_right := fun a b => le_max_right a b
    sup_le := fun a b c hac hbc => max_le hac hbc }