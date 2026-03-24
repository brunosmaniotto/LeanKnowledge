import Mathlib

variable {X : Type} [PseudoMetricSpace X]

theorem zero_dist_equivalence : Equivalence (fun x y : X => dist x y = 0) := by
  constructor
  · intro x
    exact dist_self x
  · intro x y h
    rw [dist_comm]
    exact h
  · intro x y z hxy hyz
    have h_triangle : dist x z ≤ dist x y + dist y z := dist_triangle x y z
    rw [hxy, hyz] at h_triangle
    have h_nonneg : 0 ≤ dist x z := dist_nonneg
    linarith