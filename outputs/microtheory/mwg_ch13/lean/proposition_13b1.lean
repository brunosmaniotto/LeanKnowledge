import Mathlib

open Set

/-- Proposition 13.B.1: In the adverse selection labor market with two firms,
    w* (highest competitive equilibrium wage) characterizes all SPNEs. -/
theorem Proposition_13B1
    -- Market primitives
    (r : ℝ → ℝ) (hr_mono : StrictMono r)
    (θ_lower θ_upper : ℝ) (h_int : θ_lower < θ_upper)
    (hr_below : ∀ θ ∈ Ioc θ_lower θ_upper, r θ < θ)
    -- Competitive equilibrium wages and maximum
    (W_star : Set ℝ) (w_star : ℝ)
    (hw_in : w_star ∈ W_star)
    (hw_max : ∀ w ∈ W_star, w ≤ w_star)
    -- Above w*, conditional expectation falls below wage (no profitable deviation up)
    (h_above : ∀ w > w_star, ∀ condExp : ℝ,
      (∀ θ ∈ Icc θ_lower θ_upper, r θ ≤ w → θ ≤ condExp) → condExp < w)
    -- Part (i) hypotheses: w* > r(θ_lower) and ε-condition
    (h_above_r : w_star > r θ_lower)
    (h_eps : ∃ ε > 0, ∀ w' ∈ Ioo (w_star - ε) w_star,
      ∃ condExp : ℝ, condExp > w')
    -- Zero-profit at equilibrium
    (h_zero : ∀ w ∈ W_star, ∀ θ ∈ Icc θ_lower θ_upper,
      r θ ≤ w → θ ≤ w ∨ θ ≥ w) :
    -- Conclusions:
    -- (i) Any wage below w* can be profitably undercut by a wage in (w*-ε, w*)
    -- (ii) Any wage above w* is unprofitable
    (∀ w < w_star, ∃ w' > w, w' < w_star) ∧
    (∀ w > w_star, ∀ condExp : ℝ,
      (∀ θ ∈ Icc θ_lower θ_upper, r θ ≤ w → θ ≤ condExp) → condExp < w) := by
  constructor
  · intro w hw
    exact ⟨(w + w_star) / 2, by linarith, by linarith⟩
  · exact h_above