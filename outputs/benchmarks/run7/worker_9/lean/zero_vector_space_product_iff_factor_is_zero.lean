import Mathlib

theorem zero_vector_space_product_iff_factor_zero {F V : Type*} [Field F] [AddCommGroup V] [Module F V]
    (c : F) (v : V) : c • v = 0 ↔ (c = 0 ∨ v = 0) :=
  smul_eq_zero