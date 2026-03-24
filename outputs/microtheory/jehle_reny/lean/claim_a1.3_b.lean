import Mathlib

open Metric Set

theorem claim_A1_3_b (x : ℝ) (ε : ℝ) (hε : 0 < ε) :
    Metric.ball x ε = Set.Ioo (x - ε) (x + ε) ∧
    Metric.closedBall x ε = Set.Icc (x - ε) (x + ε) := by
  exact ⟨Real.ball_eq_Ioo x ε, Real.closedBall_eq_Icc⟩