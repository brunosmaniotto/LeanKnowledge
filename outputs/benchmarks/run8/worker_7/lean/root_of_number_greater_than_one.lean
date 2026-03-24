import Mathlib

theorem nth_root_ge_one {x : ℝ} {n : ℕ} (hn : 0 < n) (hx : x ≥ 1) : x ^ (1 / (n : ℝ)) ≥ 1 :=
  Real.one_le_rpow hx (by positivity)