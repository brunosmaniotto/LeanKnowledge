import Mathlib

/-- Vickrey p36: overbidding risks loss upon winning; underbidding below equilibrium
    threshold a - a²/(4v₁) leaves a positive gap inviting bidder 2 to deviate. -/
theorem Claim_Vickrey3_p36_t (v b a v₁ : ℝ) (hv₁ : v₁ > 0) :
    (b > v → v - b < 0) ∧
    (b < a - a ^ 2 / (4 * v₁) → a - a ^ 2 / (4 * v₁) - b > 0) := by
  constructor
  · intro h; linarith
  · intro h; linarith