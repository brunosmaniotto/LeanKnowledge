import Mathlib
open Topology

theorem Exercise_4_22_b (α β c : ℝ) (hβ : 0 < β) (hac : α ≠ c) :
    0 < (α - c) ^ 2 / (8 * β) := by
  have h : α - c ≠ 0 := sub_ne_zero.mpr hac
  positivity