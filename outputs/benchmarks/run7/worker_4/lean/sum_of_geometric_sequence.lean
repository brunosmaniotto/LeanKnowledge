import Mathlib

open Finset

theorem geom_sum_eq_of_ne_one {α : Type*} [DivisionRing α] {x : α} (hx : x ≠ 1) {n : ℕ} (hn : n > 0) :
    ∑ j ∈ range n, x ^ j = (x ^ n - 1) / (x - 1) :=
  geom_sum_eq hx n