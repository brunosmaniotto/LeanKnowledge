import Mathlib

/-- The Law of Demand: From the Slutsky equation ∂x_i/∂p_i = s_ii - x_i · (∂x_i/∂y),
    where s_ii ≤ 0 (negative own-substitution term from Theorem 1.12):
    (i) A normal good (∂x_i/∂y ≥ 0) satisfies the law of demand (∂x_i/∂p_i ≤ 0).
    (ii) If ∂x_i/∂p_i > 0, then the good must be inferior (∂x_i/∂y < 0). -/
theorem law_of_demand
    (dxi_dpi : ℝ)   -- total own-price effect ∂x_i/∂p_i
    (s_ii : ℝ)      -- own-substitution effect (Slutsky term)
    (xi : ℝ)        -- quantity consumed x_i
    (dxi_dy : ℝ)    -- wealth/income effect ∂x_i/∂y
    (h_slutsky : dxi_dpi = s_ii - xi * dxi_dy)  -- Slutsky equation
    (h_sub_neg : s_ii ≤ 0)                       -- Theorem 1.12: own-substitution ≤ 0
    (h_xi_pos : xi ≥ 0) :                        -- consumption is nonneg
    -- (i) Normal good ⟹ law of demand
    (dxi_dy ≥ 0 → dxi_dpi ≤ 0) ∧
    -- (ii) Price increase raises demand ⟹ inferior good
    (dxi_dpi > 0 → dxi_dy < 0) := by
  constructor
  · intro h_normal
    rw [h_slutsky]
    nlinarith
  · intro h_giffen
    rw [h_slutsky] at h_giffen
    nlinarith