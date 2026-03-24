import Mathlib

theorem Claim_5C_i
    (p p' y y' : ℝ)
    (hy : ∀ z : ℝ, p * z ≤ p * y)
    (hy' : ∀ z : ℝ, p' * z ≤ p' * y') :
    (p - p') * (y - y') ≥ 0 := by
  have h1 : p * y ≥ p * y' := hy y'
  have h2 : p' * y' ≥ p' * y := hy' y
  nlinarith