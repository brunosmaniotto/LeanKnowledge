import Mathlib

theorem idempotent_eq_one (G : Type) [Group G] {a : G} (h : a * a = a) : a = 1 := by
  have h' : a * a = a * 1 := by rw [h, mul_one]
  exact mul_left_cancel h'