import Mathlib

structure Monopolist where
  x : ℝ → ℝ
  c : ℝ → ℝ
  x_continuous : Continuous x
  x_strict_anti_on_positive : StrictAntiOn x {p : ℝ | x p > 0}
  x_positive_at_some_price : ∃ p, x p > 0
  exists_p_bar : ∃ p_bar : ℝ, ∀ p, p_bar ≤ p → x p = 0