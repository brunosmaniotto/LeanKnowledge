import Mathlib

/-- Under increasing returns to scale, a finite maximum of profits does not exist.
    If (x', f(x')) maximizes profits and f has increasing returns (f(tx') > t·f(x') for t > 1),
    then scaling inputs by t > 1 always yields strictly higher profit, a contradiction. -/
theorem Claim_3_5_g
    (p w x' : ℝ) (f : ℝ → ℝ)
    (hp : p > 0)
    (hirs : ∀ t : ℝ, t > 1 → f (t * x') > t * f x')
    (hprofit : p * f x' - w * x' ≥ 0) :
    ∀ t : ℝ, t > 1 → p * f (t * x') - w * (t * x') > p * f x' - w * x' := by
  intro t ht
  have h1 := hirs t ht
  have h2 : 0 ≤ (t - 1) * (p * f x' - w * x') := mul_nonneg (by linarith) (by linarith)
  nlinarith [mul_lt_mul_of_pos_left h1 hp]