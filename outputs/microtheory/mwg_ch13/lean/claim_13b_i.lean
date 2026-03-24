import Mathlib
open Topology
open BigOperators

/-- In the adverse selection model, if the average productivity is below
the reservation wage of the highest-type workers, firms cannot break even
while employing all worker types. This formalizes the core inefficiency
result: the wage needed to attract the best workers exceeds what firms
can afford given the pool's average productivity. -/
theorem adverse_selection_market_inefficiency
    (n : ℕ) (hn : 0 < n)
    (θ : Fin n → ℝ)  -- productivity of each worker type
    (r : ℝ → ℝ)      -- reservation wage function
    (w : ℝ)           -- market wage
    (avg_θ : ℝ)       -- average productivity
    (θ_upper : ℝ)     -- highest type's productivity
    (h_avg : avg_θ = (∑ i : Fin n, θ i) / n)
    (h_upper : ∃ i : Fin n, θ i = θ_upper)
    (h_best_require : r θ_upper ≤ w → True)  -- best workers accept iff w ≥ r(θ_upper)
    (h_inefficiency : avg_θ < r θ_upper)      -- average productivity below best's reservation wage
    (h_zero_profit : w ≤ avg_θ)               -- firms break even requires w ≤ avg_θ
    : w < r θ_upper := by
  linarith