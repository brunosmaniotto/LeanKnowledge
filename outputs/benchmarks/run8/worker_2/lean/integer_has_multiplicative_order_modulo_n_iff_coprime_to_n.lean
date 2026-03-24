import Mathlib

-- Axiomatized sub-lemmas (as given)
axiom orderOf_pos_in_zmod_iff_isUnit (a : ℤ) (n : ℤ) : 0 < orderOf (a : ZMod (Int.natAbs n)) ↔ IsUnit (a : ZMod (Int.natAbs n))
axiom isUnit_in_zmod_iff_coprime_to_modulus (a : ℤ) (n : ℤ) : IsUnit (a : ZMod (Int.natAbs n)) ↔ Int.gcd a (Int.natAbs n) = 1
axiom int_gcd_with_n_iff_gcd_with_natAbs_n (a n : ℤ) : (Int.gcd a n = 1) ↔ (Int.gcd a (Int.natAbs n) = 1)

/--
For integers `a` and `n`, the multiplicative order of `a` modulo `n` is positive
if and only if `a` and `n` are coprime.
-/
theorem int_multiplicative_order_exists_iff_coprime (a n : ℤ) :
    (0 < orderOf (a : ZMod (Int.natAbs n))) ↔ Int.gcd a n = 1 := by
  rw [orderOf_pos_in_zmod_iff_isUnit a n,
      isUnit_in_zmod_iff_coprime_to_modulus a n,
      int_gcd_with_n_iff_gcd_with_natAbs_n a n]