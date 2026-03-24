import Mathlib

/-- In a separating equilibrium, the insurance company places probability one on the
low-risk consumer after observing their equilibrium proposal (B_l, p_l). Accepting
yields expected profits p_l - π * B_l. Since the company accepts, p_l - π * B_l ≥ 0. -/
theorem separating_equilibrium_low_risk_nonneg_profit
    (p_l B_l π : ℝ)
    (hπ_pos : 0 < π) (hπ_lt : π < 1)
    (h_accept : p_l - π * B_l ≥ 0) :
    p_l - π * B_l ≥ 0 := by
  exact h_accept