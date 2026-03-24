import Mathlib
open Topology

theorem claim_A1_3_k {n : ℕ} (x₀ : EuclideanSpace ℝ (Fin n)) (ε : ℝ) :
    Bornology.IsBounded (Metric.ball x₀ ε) :=
  Metric.isBounded_ball