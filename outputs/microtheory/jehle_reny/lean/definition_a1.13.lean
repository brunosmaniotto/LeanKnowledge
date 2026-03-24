import Mathlib

open Metric
open Topology

/-- Definition A1.13 (JR). The sequence `x` converges to `a` in `ℝⁿ` if for every
    `ε > 0`, there exists `K` such that `x k ∈ B_ε(a)` for all `k` exceeding `K`. -/
def MWG.SeqConvergesTo {n : ℕ} (x : ℕ → EuclideanSpace ℝ (Fin n))
    (a : EuclideanSpace ℝ (Fin n)) : Prop :=
  ∀ ε > 0, ∃ K : ℕ, ∀ k : ℕ, K < k → x k ∈ ball a ε