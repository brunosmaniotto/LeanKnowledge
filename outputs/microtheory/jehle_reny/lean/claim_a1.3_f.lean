import Mathlib

theorem claim_A1_3_f {X : Type*} [PseudoMetricSpace X] (x₀ : X) (ε : ℝ) :
    IsClosed (Metric.closedBall x₀ ε) :=
  Metric.isClosed_closedBall