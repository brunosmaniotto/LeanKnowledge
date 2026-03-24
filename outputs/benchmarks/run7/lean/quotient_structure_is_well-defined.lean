import Mathlib

variable {S : Type u} [MulOneClass S]

/-- The induced operation on the quotient by a congruence is well-defined. -/
theorem quotient_op_well_defined (c : Con S) (x₁ x₂ y₁ y₂ : S) (hx : c x₁ x₂) (hy : c y₁ y₂) :
    c.mk' (x₁ * y₁) = c.mk' (x₂ * y₂) :=
  Quotient.sound (c.mul hx hy)