import Mathlib

variable (D : Type) [CommRing D] [IsDomain D]

/-- The set of nonzero elements of the fraction field of an integral domain is closed under multiplication. -/
theorem inverse_completion_nonzero_closed (x y : FractionRing D) (hx : x ≠ 0) (hy : y ≠ 0) :
    x * y ≠ 0 :=
  mul_ne_zero hx hy