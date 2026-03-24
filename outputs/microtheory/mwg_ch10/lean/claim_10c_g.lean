import Mathlib

-- Let `P` represent the demand function (marginal social benefit)
-- and `C'` represent the marginal cost function.
-- Both map a quantity (ℝ) to a price/cost (ℝ).
variable (P C' : ℝ → ℝ)

-- Let `x_star` be the aggregate output level at equilibrium,
-- and `p_star` be the equilibrium price.
variable (x_star p_star : ℝ)

theorem Claim_10C_g (h_demand_eq_price : P x_star = p_star)
    (h_price_eq_marginal_cost : p_star = C' x_star) :
    P x_star = C' x_star :=
  calc
    P x_star = p_star      := h_demand_eq_price
    _        = C' x_star  := h_price_eq_marginal_cost