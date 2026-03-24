import Mathlib

theorem cartesian_product_empty_iff (S : Set α) (T : Set β) : S ×ˢ T = ∅ ↔ S = ∅ ∨ T = ∅ :=
  Set.prod_eq_empty_iff