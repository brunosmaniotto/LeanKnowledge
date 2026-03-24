import Mathlib

-- This sub-lemma states that the GCD of two integers `a` and `b` divides any
-- integer linear combination of them. This is a fundamental property of GCDs.
lemma gcd_dvd_int_lin_comb (a b m n : ℤ) : (Int.gcd a b : ℤ) ∣ m * a + n * b := by
  -- A number that divides `x` and `y` also divides their sum `x + y`.
  -- So, we can prove that the GCD divides `m * a` and `n * b` separately.
  apply dvd_add
  -- To prove `gcd ∣ m * a`, we use the fact that `gcd ∣ a`.
  -- A number that divides `a` also divides any multiple `m * a`.
  · apply dvd_mul_of_dvd_right
    -- The GCD of `a` and `b` divides `a`.
    exact Int.gcd_dvd_left a b
  -- Similarly, to prove `gcd ∣ n * b`, we use `gcd ∣ b`.
  · apply dvd_mul_of_dvd_right
    -- The GCD of `a` and `b` divides `b`.
    exact Int.gcd_dvd_right a b

-- This sub-lemma shows that if the GCD of `a` and `b` (which is a natural number)
-- divides 1 when cast to an integer, then the GCD must be 1.