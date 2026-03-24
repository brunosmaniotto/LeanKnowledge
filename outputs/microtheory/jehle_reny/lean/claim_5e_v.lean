import Mathlib
open Filter Topology
open Topology

theorem Claim_5e_v (a : ℕ → ℝ) (L : ℝ) (h : Tendsto a atTop (nhds L)) :
    Bornology.IsBounded (Set.range a) := by
  have hc : CauchySeq a := h.cauchySeq
  exact hc.isBounded_range