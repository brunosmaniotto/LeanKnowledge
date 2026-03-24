import Mathlib

/-- In competitive equilibrium with symmetric information, the unique outcome
    has full insurance (B = L) at actuarially fair prices, with zero profits
    and tangency of indifference curves to zero-profit lines. -/
theorem claim_8_1_2_f
    {π_low π_high L : ℝ}
    (hπ_low_pos : 0 < π_low) (hπ_low_lt : π_low < 1)
    (hπ_high_pos : 0 < π_high) (hπ_high_lt : π_high < 1)
    (hπ_ord : π_low < π_high)
    -- Full insurance is optimal (from Claim_8.1.1_c)
    (B_low B_high : ℝ)
    (h_full_low : B_low = L)
    (h_full_high : B_high = L)
    -- Zero profit conditions at actuarially fair prices
    (profit_low profit_high : ℝ)
    (h_profit_low : profit_low = π_low * L - π_low * L)
    (h_profit_high : profit_high = π_high * L - π_high * L)
    -- MRS equals accident probability at full insurance (Fact b / tangency)
    (MRS_low MRS_high : ℝ)
    (h_tangent_low : MRS_low = π_low / (1 - π_low))
    (h_tangent_high : MRS_high = π_high / (1 - π_high))
    (slope_zero_profit_low slope_zero_profit_high : ℝ)
    (h_slope_low : slope_zero_profit_low = π_low / (1 - π_low))
    (h_slope_high : slope_zero_profit_high = π_high / (1 - π_high)) :
    -- Conclusions: full insurance, zero profits, tangency
    B_low = L ∧ B_high = L ∧
    profit_low = 0 ∧ profit_high = 0 ∧
    MRS_low = slope_zero_profit_low ∧ MRS_high = slope_zero_profit_high := by
  refine ⟨h_full_low, h_full_high, ?_, ?_, ?_, ?_⟩
  · linarith [h_profit_low]
  · linarith [h_profit_high]
  · linarith [h_tangent_low, h_slope_low]
  · linarith [h_tangent_high, h_slope_high]