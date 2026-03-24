import Mathlib
open Topology

noncomputable section

/-- The principal's optimal contract in Example 23.F.1 (hidden information) -/
theorem optimal_contract_hidden_information
    (v g Φ φ e e_star v' g' : ℝ → ℝ)
    (θ_low θ_high : ℝ)
    (h_range : θ_low < θ_high)
    -- First-best effort satisfies v'(e*(θ)) + g'(e*(θ))·θ = 0
    (first_best_cond : ∀ θ, θ_low ≤ θ → θ ≤ θ_high →
      v' (e_star θ) + g' (e_star θ) * θ = 0)
    -- FOC uniqueness
    (foc_unique : ∀ a b t : ℝ,
      v' a + g' a * t = 0 → v' b + g' b * t = 0 → a = b)
    -- Virtual type is strictly below true type for interior types
    (virtual_below : ∀ θ, θ_low ≤ θ → θ < θ_high →
      θ - (1 - Φ θ) / φ θ < θ)
    -- Effort is strictly monotone in virtual type argument
    (effort_monotone : ∀ t₁ t₂ : ℝ,
      t₁ < t₂ →
      (∀ a, v' a + g' a * t₁ = 0 → ∀ b, v' b + g' b * t₂ = 0 → a < b))
    -- Second-best FOC: v'(e(θ)) + g'(e(θ))·(θ - (1-Φ(θ))/φ(θ)) = 0
    (h_foc : ∀ θ, θ_low ≤ θ → θ ≤ θ_high →
      v' (e θ) + g' (e θ) * (θ - (1 - Φ θ) / φ θ) = 0)
    (h_top : Φ θ_high = 1) :
    e θ_high = e_star θ_high ∧
    (∀ θ, θ_low ≤ θ → θ < θ_high → e θ < e_star θ) := by
  constructor
  · -- At θ_high: Φ(θ_high) = 1 so virtual type = θ_high
    have h1 := h_foc θ_high (le_of_lt h_range) le_rfl
    rw [h_top, sub_self, zero_div, sub_zero] at h1
    have h2 := first_best_cond θ_high (le_of_lt h_range) le_rfl
    exact foc_unique (e θ_high) (e_star θ_high) θ_high h1 h2
  · -- For θ < θ_high: virtual type < θ, so effort is distorted downward
    intro θ hlo hhi
    have h_sb := h_foc θ hlo (le_of_lt hhi)
    have h_fb := first_best_cond θ hlo (le_of_lt hhi)
    have h_vt := virtual_below θ hlo hhi
    exact effort_monotone (θ - (1 - Φ θ) / φ θ) θ h_vt (e θ) h_sb (e_star θ) h_fb

end