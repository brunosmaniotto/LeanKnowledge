import Mathlib

/-!
This file proves that the sign of a k-cycle is `(-1)^(k-1)`.
The proof is assembled from two helper lemmas, as requested.
-/

-- Sub-lemma 1: The coercion of `(-1 : ℤˣ) ^ n` from units of integers to integers.
lemma units_val_pow_neg_one (n : ℕ) : ((-1 : ℤˣ) ^ n : ℤ) = (-1 : ℤ) ^ n := by
  -- The coercion `↑` from `ℤˣ` to `ℤ` is a monoid homomorphism (`Units.valHom`).
  -- `simp` uses `MonoidHom.map_pow` to move the exponent outside the coercion,
  -- changing the goal to `(↑(-1 : ℤˣ) : ℤ) ^ n = (-1 : ℤ) ^ n`.
  -- Then, `simp` uses `Units.val_neg_one` to simplify `↑(-1 : ℤˣ)` to `-1 : ℤ`.
  -- The goal becomes `(-1 : ℤ) ^ n = (-1 : ℤ) ^ n`, which is true by reflexivity.
  simp

-- Sub-lemma 2: The sign of a k-cycle, expressed in the group of units `ℤˣ`.