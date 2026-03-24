import Mathlib

theorem Closure_of_Open_Ball_in_Metric_Space {A : Type*} [MetricSpace A] (x y : A) (ε : ℝ) :
    y ∈ closure (Metric.ball x ε) → dist x y ≤ ε := by
  intro h
  rw [← Metric.mem_closedBall']
  exact Metric.closure_ball_subset_closedBall h