import Mathlib

open Set Metric

theorem Distinct_Points_in_Metric_Space_have_Disjoint_Open_Balls
    {A : Type*} [MetricSpace A] {x y : A} (h : x ≠ y) :
    ∃ ε > 0, Disjoint (ball x ε) (ball y ε) := by
  use dist x y / 2
  have h_dist_pos : 0 < dist x y := dist_pos.mpr h
  constructor
  · exact div_pos h_dist_pos (by norm_num)
  · rw [disjoint_left]
    intro z hzx hzy
    simp only [mem_ball] at hzx hzy
    have h_tri := dist_triangle x z y
    rw [dist_comm z x] at hzx
    linarith [hzx, hzy, h_tri]