import Mathlib

variable {X : Type} [MetricSpace X]

theorem reverse_triangle_inequality (x y z : X) : |dist x z - dist y z| ≤ dist x y := by
  have h1 : dist x z ≤ dist x y + dist y z := dist_triangle x y z
  have h2 : dist y z ≤ dist x y + dist x z := by
    calc dist y z ≤ dist y x + dist x z := dist_triangle y x z
         _ = dist x y + dist x z := by rw [dist_comm y x]
  rw [abs_sub_le_iff]
  constructor <;> linarith