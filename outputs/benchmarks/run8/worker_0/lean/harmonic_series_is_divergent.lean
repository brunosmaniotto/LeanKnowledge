import Mathlib

theorem harmonic_series_diverges : ¬ Summable (fun n : ℕ => 1 / (n : ℝ)) := by
  intro h
  have h' : Summable (fun n : ℕ => 1 / (n : ℝ) ^ (1 : ℝ)) := by
    simpa [Real.rpow_one] using h
  have := (Real.summable_one_div_nat_rpow (p := 1)).1 h'
  linarith