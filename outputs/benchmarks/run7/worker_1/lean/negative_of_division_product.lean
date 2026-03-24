import Mathlib

-- First sub-lemma (provided)
lemma neg_mul_unit_inv {R : Type*} [CommRing R] (x : R) (z : Rˣ) : -(x * ↑z⁻¹) = (-x) * ↑z⁻¹ := by
  exact (neg_mul x ↑z⁻¹).symm

-- Second sub-lemma: (-x) * z⁻¹ = x * (-z)⁻¹