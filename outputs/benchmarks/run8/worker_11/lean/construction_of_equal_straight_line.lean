import Mathlib

variable {E : Type _} [NormedAddCommGroup E]

theorem exists_segment_with_same_length (A B C : E) : ∃ L : E, dist A L = dist B C := by
  use A + (C - B)
  calc
    dist A (A + (C - B)) = ‖(A + (C - B)) - A‖ := by rw [dist_eq_norm']
    _ = ‖C - B‖ := by simp
    _ = dist C B := by rw [dist_eq_norm]
    _ = dist B C := by rw [dist_comm]