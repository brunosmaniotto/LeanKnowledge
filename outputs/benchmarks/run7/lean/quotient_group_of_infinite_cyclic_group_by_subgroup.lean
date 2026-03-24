import Mathlib

open AddSubgroup

/-- The cyclic group of order `n` is isomorphic to the quotient group `ℤ ⧸ nℤ`. -/
def cyclic_group_iso (n : ℕ) : ℤ ⧸ zmultiples (n : ℤ) ≃+ ZMod n :=
  Int.quotientZMultiplesEquivZMod n