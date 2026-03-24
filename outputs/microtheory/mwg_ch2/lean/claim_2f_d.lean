import Mathlib

/-- The Slutsky substitution effect: s_{lk}(p, w) = ∂x_l/∂p_k + (∂x_l/∂w) * x_k -/
theorem slutsky_substitution_effect
    (dxl_dpk : ℝ)   -- ∂x_l/∂p_k (direct price effect on good l from price of good k)
    (dxl_dw : ℝ)    -- ∂x_l/∂w (wealth effect on good l)
    (xk : ℝ)        -- consumption of good k
    (dpk : ℝ)       -- differential price change in good k
    (s_lk : ℝ)      -- substitution effect
    (h_def : s_lk = dxl_dpk + dxl_dw * xk) :
    s_lk * dpk = dxl_dpk * dpk + dxl_dw * (xk * dpk) := by
  subst h_def
  ring