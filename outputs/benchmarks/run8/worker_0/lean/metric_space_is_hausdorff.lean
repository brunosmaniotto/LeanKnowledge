import Mathlib

open Metric

instance {α : Type u} [MetricSpace α] : T2Space α := by
  refine ⟨fun x y hxy => ?_⟩
  have h_pos : 0 < dist x y := dist_pos.mpr hxy
  set r := dist x y / 2 with hr_def
  have hr_pos : 0 < r := half_pos h_pos
  have h_sum_eq : r + r = dist x y := by
    rw [← two_mul, hr_def]
    ring
  have h_sum : r + r ≤ dist x y := h_sum_eq.le
  exact ⟨ball x r, ball y r, isOpen_ball, isOpen_ball, mem_ball_self hr_pos, mem_ball_self hr_pos,
    ball_disjoint_ball h_sum⟩