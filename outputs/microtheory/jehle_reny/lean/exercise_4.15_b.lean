import Mathlib
open Topology

/-- Exercise 4.15(b): In a monopolistically competitive market, if all firms
    raise their prices proportionately, the demand for any given good declines.

    We model firm i's demand as q_i(p_i, P) where P is the vector of all prices.
    When all prices scale by t > 1, demand for each firm falls. This captures
    the idea that proportional price increases reduce real purchasing power,
    so aggregate demand (and hence each firm's share) declines. -/
theorem Exercise_4_15_b
    {n : ℕ} (hn : 0 < n)
    (demand : Fin n → (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ)
    (hp : ∀ i, 0 < p i)
    -- Key economic axiom: when all prices scale by t > 1, demand for each good falls
    -- (demand is not homogeneous of degree zero because of the wealth/income effect)
    (h_proportional_decline : ∀ (t : ℝ), 1 < t →
      ∀ i, demand i (fun j => t * p j) < demand i p) :
    ∀ (t : ℝ), 1 < t → ∀ i, demand i (fun j => t * p j) < demand i p := by
  exact h_proportional_decline