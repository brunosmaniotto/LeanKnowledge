import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A single representative consumer can stand for a population of identical consumers:
    if all N consumers have the same demand function, aggregate demand equals
    N times the representative's demand. -/
theorem representative_consumer_aggregation
    {N : ℕ} (hN : 0 < N)
    (demand : ℝ → ℝ)  -- individual demand as a function of price
    (p : ℝ) :
    ∑ _i ∈ Finset.range N, demand p = ↑N * demand p := by
  simp [Finset.sum_const, nsmul_eq_mul]