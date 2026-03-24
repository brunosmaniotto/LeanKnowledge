import Mathlib.Geometry.Euclidean.Basic

open Affine

variable {E : Type _} [NormedAddCommGroup E] [InnerProductSpace ℝ E] {P : Type _} [MetricSpace P]
  [NormedAddTorsor E P]

theorem lines_joining_equal_parallel_are_equal_parallel (A B C D : P) (h : B -ᵥ A = D -ᵥ C) :
    C -ᵥ A = D -ᵥ B := by
  calc
    C -ᵥ A = (C -ᵥ B) + (B -ᵥ A) := by rw [← vsub_add_vsub_cancel C B A]
    _ = (C -ᵥ B) + (D -ᵥ C) := by rw [h]
    _ = (D -ᵥ C) + (C -ᵥ B) := by abel
    _ = D -ᵥ B := by rw [vsub_add_vsub_cancel]