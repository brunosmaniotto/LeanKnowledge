import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Because each individual's VCG cost is always non-negative,
    the VCG mechanism never runs a deficit (total payments ≥ 0). -/
theorem vcg_no_deficit
    {I : Type*} [Fintype I] [DecidableEq I]
    (c_vcg : I → ℝ)
    (h_nonneg : ∀ i, 0 ≤ c_vcg i) :
    0 ≤ ∑ i : I, c_vcg i :=
  Finset.sum_nonneg fun i _ => h_nonneg i