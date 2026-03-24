import Mathlib

open Real

theorem floor_sum_le (x y : ℝ) : ⌊x⌋ + ⌊y⌋ ≤ ⌊x + y⌋ := by
  apply Int.le_floor.2
  push_cast
  exact add_le_add (Int.floor_le x) (Int.floor_le y)