import Mathlib

open Set
open scoped BigOperators

variable {V : Type _} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
variable {P : Type _} [MetricSpace P] [NormedAddTorsor V P]

theorem point_inside_triangle_inequality (A B C D E : P)
    (hE_between : Wbtw ℝ B E C) (hD_between : Wbtw ℝ A D E) :
    dist A D + dist D B ≤ dist A C + dist C B := by
  have h_dist_AE : dist A D + dist D E = dist A E := Wbtw.dist_add_dist hD_between
  have h_dist_BC : dist B E + dist E C = dist B C := Wbtw.dist_add_dist hE_between
  have h_triangle1 : dist D B ≤ dist D E + dist E B := dist_triangle D E B
  have h_triangle2 : dist A E ≤ dist A C + dist C E := dist_triangle A C E
  have h1 : dist A D + dist D B ≤ dist A E + dist E B := by
    linarith [h_dist_AE, h_triangle1]
  have h2 : dist A E + dist E B ≤ dist A C + dist C B := by
    have h3 : dist C B = dist C E + dist E B := by
      calc dist C B = dist B C := dist_comm C B
        _ = dist B E + dist E C := h_dist_BC.symm
        _ = dist E B + dist C E := by rw [dist_comm B E, dist_comm E C]
        _ = dist C E + dist E B := by ring
    rw [h3]
    linarith
  linarith