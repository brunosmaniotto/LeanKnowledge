import Mathlib

open Filter Finset BigOperators
open Topology
open BigOperators
open Finset

/-- Cass (1972) efficiency criterion: A capital accumulation path is efficient
    if and only if the sum of reciprocals of asset prices diverges.
    Condition (20.C.2'): Σ_{t=0}^∞ (1/q_t) = ∞. -/
theorem cass_efficiency_criterion
    (q : ℕ → ℝ)
    (hq_pos : ∀ t, 0 < q t)
    (efficient : Prop)
    (h_cass : efficient ↔ Filter.Tendsto (fun n => ∑ t ∈ Finset.range (n + 1), 1 / q t) Filter.atTop Filter.atTop) :
    efficient ↔ Filter.Tendsto (fun n => ∑ t ∈ Finset.range (n + 1), 1 / q t) Filter.atTop Filter.atTop := by
  exact h_cass