import Mathlib

-- First sub-lemma: simplifying u * 1 = u⁻¹
lemma unit_mul_one_eq_inverse_iff {S : Type*} [Monoid S] (u : Sˣ) : u * 1 = u⁻¹ ↔ u = u⁻¹ := by
  simp [mul_one]

-- Second sub-lemma: u * u * u⁻¹ simplifies to u