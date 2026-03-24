import Mathlib
open Set Pointwise
open Topology

theorem claim_A2_5_b {n : ℕ} (A B : Set (EuclideanSpace ℝ (Fin n)))
    (hA_closed : IsClosed A) (hA_bdd : Bornology.IsBounded A) (hB_closed : IsClosed B) :
    IsClosed (A - B) := by
  have hA_compact : IsCompact A :=
    Metric.isCompact_of_isClosed_isBounded hA_closed hA_bdd
  rw [sub_eq_add_neg]
  exact hB_closed.neg.add_left_of_isCompact hA_compact