import Mathlib

theorem Units.inv_div_chain {R : Type _} [CommRing R] (a b : Units R) :
    (a / b)⁻¹ = 1 / (a / b) ∧ 1 / (a / b) = b / a := by
  constructor
  · rw [one_div]
  · rw [one_div, div_eq_mul_inv, div_eq_mul_inv, mul_inv_rev, inv_inv]