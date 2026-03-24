import Mathlib

open LinearOrder

theorem sum_eq_max_add_min {α : Type _} [LinearOrder α] [AddCommSemigroup α] (a b : α) :
    a + b = max a b + min a b := by
  rcases le_total a b with (h | h)
  · rw [max_eq_right h, min_eq_left h, add_comm]
  · rw [max_eq_left h, min_eq_right h]