import Mathlib

-- Proved sub-lemmas

lemma int_pow_dvd_iff_nat_pow_dvd (p k l : ℕ) : ((p : ℤ) ^ k ∣ (p : ℤ) ^ l) ↔ (p ^ k ∣ p ^ l) := by
  -- First, we rewrite the powers of the casted integer `(p : ℤ)`
  -- into casts of the natural number powers `p ^ k` and `p ^ l`.
  -- The lemma `Nat.cast_pow` states `↑(a ^ b) = (↑a) ^ b`, so we use it in reverse.
  rw [← Nat.cast_pow, ← Nat.cast_pow]
  -- The goal is now `(↑(p ^ k) : ℤ) ∣ (↑(p ^ l) : ℤ) ↔ p ^ k ∣ p ^ l`.
  -- This is exactly the statement of `Int.natCast_dvd_natCast`, which provides
  -- the equivalence between divisibility of coerced naturals in ℤ and
  -- divisibility in ℕ.
  exact Int.natCast_dvd_natCast