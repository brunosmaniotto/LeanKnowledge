import Mathlib

open Set

theorem nat_strict_lower_closure (n : ℕ) : Set.Iio (n + 1) = Set.Iio n ∪ {n} := by
  ext m
  simp [Nat.lt_succ_iff, le_iff_lt_or_eq]