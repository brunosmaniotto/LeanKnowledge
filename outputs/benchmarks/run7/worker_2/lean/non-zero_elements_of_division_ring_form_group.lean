import Mathlib

-- Sub-lemma: nonzero multiplication is closed
lemma nonzero_mul_closed {R : Type*} [DivisionRing R] (a b : R) (ha : a ≠ 0) (hb : b ≠ 0) : a * b ≠ 0 := by
  exact mul_ne_zero ha hb

-- Sub-lemma: units form a group (this is automatic)
instance units_group_instance {R : Type*} [DivisionRing R] : Group Rˣ := inferInstance

-- Main theorem: Non-zero elements of division ring form a group