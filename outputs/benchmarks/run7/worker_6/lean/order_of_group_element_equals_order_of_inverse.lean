import Mathlib

variable {G : Type} [Group G]

/-- The order of an element equals the order of its inverse. -/
theorem order_of_eq_order_of_inv (x : G) : orderOf x = orderOf (x⁻¹) := by
  rw [orderOf_inv]