import Mathlib
open Topology

/-- When z_k(p) > 0, there is excess demand (demand exceeds supply).
    When z_k(p) < 0, there is excess supply (supply exceeds demand).
    Here z_k(p) = demand_k(p) - supply_k(p). -/
theorem Claim_5_2_excess_demand_interpretation
    (demand supply : ℝ) (z : ℝ) (hz : z = demand - supply) :
    (z > 0 → demand > supply) ∧ (z < 0 → supply > demand) := by
  constructor <;> intro h <;> linarith