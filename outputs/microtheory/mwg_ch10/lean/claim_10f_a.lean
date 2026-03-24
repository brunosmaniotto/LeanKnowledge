import Mathlib

open Real

theorem Claim_10F_a (c p_star q_star x_c J_star : ℝ)
    (hc_pos : c > 0) -- Constant marginal cost c is positive
    (hxc_pos : x_c > 0) -- Aggregate consumption x(c) is positive
    (hp_le_c : p_star ≤ c) -- Condition (i) of equilibrium: Price must be less than or equal to cost
    (hq_pos : q_star > 0) -- Condition (ii) of equilibrium: Firm output is positive
    (h_zero_profit : (p_star - c) * q_star = 0) -- Condition (iii) of equilibrium: Zero profit condition
    (h_aggregate_consumption : J_star * q_star = x_c) -- Definition of aggregate consumption in equilibrium
    (hJ_pos : J_star > 0) -- Number of firms is positive
    : p_star = c :=
by
  -- From `q_star > 0`, we know `q_star ≠ 0`.
  have hq_ne_zero : q_star ≠ 0 := ne_of_gt hq_pos

  -- The zero profit condition `(p_star - c) * q_star = 0` implies that either
  -- `p_star - c = 0` or `q_star = 0`, by `mul_eq_zero`.
  have h_factors_eq_zero : p_star - c = 0 ∨ q_star = 0 := mul_eq_zero.mp h_zero_profit

  -- Since we know `q_star ≠ 0`, we can resolve the disjunction to `p_star - c = 0`.
  have h_p_minus_c_eq_zero : p_star - c = 0 := Or.resolve_right h_factors_eq_zero hq_ne_zero

  -- From `p_star - c = 0`, we can algebraically deduce `p_star = c`.
  linarith [h_p_minus_c_eq_zero]