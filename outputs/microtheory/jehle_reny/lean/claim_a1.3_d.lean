import Mathlib

open Metric
open Topology

theorem open_ball_is_open {n : ℕ} (x₀ : EuclideanSpace ℝ (Fin n)) (ε : ℝ) :
    IsOpen (Metric.ball x₀ ε) :=
  isOpen_ball