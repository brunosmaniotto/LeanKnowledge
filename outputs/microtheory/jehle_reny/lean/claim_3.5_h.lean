import Mathlib

theorem Claim_3_5_h
    (f : ℝ → ℝ)
    (p w x : ℝ)
    (hp : p > 0)
    (hcrs : ∀ (t y : ℝ), t > 0 → f (t * y) = t * f y)
    : (∀ t : ℝ, t > 0 → p * f (t * x) - w * (t * x) = t * (p * f x - w * x)) ∧
      (p * f x - w * x = 0 → ∀ t : ℝ, t > 0 → p * f (t * x) - w * (t * x) = 0) := by
  constructor
  · intro t ht
    rw [hcrs t x ht]
    ring
  · intro hzero t ht
    rw [hcrs t x ht]
    linarith [mul_eq_zero_of_right t hzero]