import Mathlib

open Set

theorem definite_integral_zero_interval (a b : ℝ) (hab : a < b) (c : ℝ) (hc : c ∈ Icc a b) (f : ℝ → ℝ) :
    ∫ t in c..c, f t = 0 := by
  simp