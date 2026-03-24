import Mathlib

open AddSubgroup

/-- Convert an additive subgroup of ℤ to an ideal of ℤ with the same carrier set. -/
def AddSubgroup.toIdeal (H : AddSubgroup ℤ) : Ideal ℤ :=
  { carrier := H
    zero_mem' := H.zero_mem
    add_mem' := H.add_mem
    smul_mem' := fun r x hx => H.zsmul_mem hx r
  }

-- The carrier of the resulting ideal is exactly the original subgroup.