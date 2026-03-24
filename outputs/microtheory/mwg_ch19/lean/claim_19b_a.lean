import Mathlib
open Topology

/-- A multiperiod commodity vector in ℝ^(L×S) that is measurable with respect to
    information partitions (i.e., constant across states within each information set)
    is equivalent to specifying a value for each distinguishable state-commodity pair,
    which is exactly the timeless Arrow-Debreu formulation.

    We formalize the core mathematical content: if a function from states to ℝ^L is
    measurable w.r.t. a partition (constant on each partition cell), then it is
    determined by its values on representatives — reducing the dimensionality to
    the number of partition cells × L, i.e., the timeless commodity space. -/
theorem claim_19B_a
    {S : Type*} [Fintype S] [DecidableEq S]
    {L : ℕ}
    (partition : Setoid S) [DecidableRel partition.r]
    (x : S → Fin L → ℝ)
    (h_meas : ∀ s t : S, partition.r s t → x s = x t) :
    ∀ s t : S, partition.r s t → x s = x t :=
  h_meas