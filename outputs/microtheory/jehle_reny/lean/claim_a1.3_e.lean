import Mathlib

theorem closed_interval_is_closed (a b : ℝ) : IsClosed (Set.Icc a b) :=
  isClosed_Icc