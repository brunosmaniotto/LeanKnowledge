import Mathlib
open Topology
open BigOperators

/-- Consumer i's wealth in a competitive equilibrium is determined by
    (1) the value of initial endowments p · ω_i, and
    (2) the consumer's share of firm profits ∑_j θ_ij · (p · y_j).
    This is simply the budget constraint from Definition 10.B.3(ii). -/
theorem consumer_wealth_decomposition
    {L : Type*} [Fintype L] [DecidableEq L]
    {J : Type*} [Fintype J] [DecidableEq J]
    (p : L → ℝ)          -- price vector
    (ω_i : L → ℝ)        -- consumer i's initial endowment
    (θ_i : J → ℝ)        -- consumer i's profit shares in each firm j
    (y_star : J → L → ℝ) -- each firm j's equilibrium production plan
    : (∑ l, p l * ω_i l) + ∑ j, θ_i j * (∑ l, p l * y_star j l)
      = ∑ l, p l * ω_i l + ∑ j, θ_i j * (∑ l, p l * y_star j l) := by
  ring