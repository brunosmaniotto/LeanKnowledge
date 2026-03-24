import Mathlib

/-- With actuarially fair insurance (ρ = α), a risk-averse individual (u'' < 0,
    so u' is strictly decreasing) fully insures: the optimal coverage is x* = L,
    and wealth is constant at w₀ − αL in both states. -/
theorem claim_2_7_b
    (u' : ℝ → ℝ)
    (h_anti : StrictAnti u')
    (w₀ L α x : ℝ)
    (hα_pos : 0 < α) (hα_lt : α < 1)
    -- FOC: (1-α)α·u'(w_acc) = α(1-α)·u'(w_no_acc) simplifies to:
    (h_foc : u' (w₀ - α * x - L + x) = u' (w₀ - α * x)) :
    -- Full insurance: x* = L, and accident wealth = no-accident wealth = w₀ - αL
    x = L ∧ w₀ - α * L - L + L = w₀ - α * L := by
  exact ⟨by linarith [h_anti.injective h_foc], by ring⟩