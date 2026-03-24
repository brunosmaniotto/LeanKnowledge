import Mathlib

/-- The disutility function g(e, θ) for the moral hazard model.
    Higher θ means more productive (lower total and marginal disutility). -/
structure DisutilityFunction where
  /-- The disutility function g(e, θ) -/
  g : ℝ → ℝ → ℝ
  /-- g(0, θ) = 0 for all θ -/
  zero_at_zero : ∀ θ : ℝ, g 0 θ = 0
  /-- gₑ(e, θ) > 0 for e > 0 -/
  ge_pos : ∀ e θ : ℝ, e > 0 → deriv (fun e' => g e' θ) e > 0
  /-- gₑ(0, θ) = 0 -/
  ge_zero_at_zero : ∀ θ : ℝ, deriv (fun e' => g e' θ) 0 = 0
  /-- gₑₑ(e, θ) > 0 for all e (strict convexity in e) -/
  gee_pos : ∀ e θ : ℝ, deriv (deriv (fun e' => g e' θ)) e > 0
  /-- gθ(e, θ) < 0 for all e (higher θ reduces disutility) -/
  gtheta_neg : ∀ e θ : ℝ, deriv (fun θ' => g e θ') θ < 0
  /-- gₑθ(e, θ) < 0 for e > 0 (single-crossing: higher θ reduces marginal disutility) -/
  ge_theta_neg : ∀ e θ : ℝ, e > 0 →
    deriv (fun θ' => deriv (fun e' => g e' θ') e) θ < 0
  /-- gₑθ(0, θ) = 0 -/
  ge_theta_zero_at_zero : ∀ θ : ℝ,
    deriv (fun θ' => deriv (fun e' => g e' θ') 0) θ = 0