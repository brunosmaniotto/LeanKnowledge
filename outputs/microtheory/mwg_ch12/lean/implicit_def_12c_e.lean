import Mathlib
open Topology

-- Definition (Implicit_Def_12C_e): Product differentiation in oligopoly:
-- J ≥ 1 firms each produce at constant marginal cost c > 0.
-- Demand for firm j's product is given by the continuous function x_j(p_j, p_{-j}),
-- where p_{-j} is the vector of rivals' prices.
-- Each firm j takes rivals' prices as given and chooses p_j to maximize (p_j - c)x_j(p_j, p_{-j}).

/-- An oligopoly market with product differentiation. -/
structure Oligopoly where
  /-- The number of firms in the oligopoly. -/
  J : ℕ
  /-- There is at least one firm. -/
  hJ : J ≥ 1
  /-- The constant marginal cost of production for each firm. -/
  c : ℝ
  /-- The marginal cost is strictly positive. -/
  hc : c > 0
  /-- The demand function for firm `j`'s product, given the vector of all firms' prices `p`.
      `x j p` represents `x_j(p_j, p_{-j})` where `p_j = p j` and `p_{-j}` are the other components of `p`. -/
  x : Fin J → (Fin J → ℝ) → ℝ
  /-- The demand function for each firm is continuous with respect to the price vector. -/
  hx_continuous : ∀ j : Fin J, Continuous (x j)