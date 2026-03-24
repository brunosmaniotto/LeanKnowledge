import Mathlib

/-- In an all-pay auction with 2 bidders, values iid Uniform[0,1],
    there exists a symmetric BNE with quadratic bidding b(v) = γ + δv + φv².
    The equilibrium is b(v) = v²/2 (γ=0, δ=0, φ=1/2). -/
theorem Exercise_7_24_a :
    ∃ γ δ φ : ℝ,
      -- FOC from payoff maximization: b'(v) = δ + 2φv = v
      (∀ v : ℝ, δ + 2 * φ * v = v) ∧
      -- Boundary condition: b(0) = 0
      (γ + δ * 0 + φ * 0 ^ 2 = 0) ∧
      -- Non-negative bids on [0,1]
      (∀ v : ℝ, 0 ≤ v → v ≤ 1 → 0 ≤ γ + δ * v + φ * v ^ 2) ∧
      -- Monotonicity: higher value ⟹ higher bid
      (∀ v₁ v₂ : ℝ, 0 ≤ v₁ → v₁ < v₂ → v₂ ≤ 1 →
        γ + δ * v₁ + φ * v₁ ^ 2 < γ + δ * v₂ + φ * v₂ ^ 2) := by
  refine ⟨0, 0, 1 / 2, fun v => by ring, by norm_num,
    fun v _ _ => by nlinarith [sq_nonneg v],
    fun v₁ v₂ hv₁ hlt _ => ?_⟩
  have : 0 < (v₂ - v₁) * (v₂ + v₁) := by
    apply mul_pos <;> linarith
  nlinarith