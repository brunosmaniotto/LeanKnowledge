import Mathlib

/-- An actuarially fair insurance price (yielding zero expected profits for the
    insurance company) satisfies ρ = α, where α is the probability of accident.
    The expected profit per dollar of insurance is α(ρ - 1) + (1 - α)ρ.
    Setting this to zero gives ρ = α. -/
theorem actuarially_fair_insurance_price
    (α ρ : ℝ)
    (hα_pos : 0 < α) (hα_lt : α < 1)
    (h_zero_profit : α * (ρ - 1) + (1 - α) * ρ = 0) :
    ρ = α := by
  linarith