import Mathlib
open Topology

/-- Example 2.5: For u(w) = ln(w), the certainty equivalent of a fair gamble
    (½ ◦ (w₀+h), ½ ◦ (w₀−h)) is CE = √(w₀²−h²) < w₀ = E(g),
    and the risk premium P = w₀ − √(w₀²−h²) > 0. -/
theorem Example_2_5
    (w₀ h : ℝ) (hw₀ : 0 < w₀) (hh : 0 < h) (hhw : h < w₀) :
    (1 / 2) * Real.log (w₀ + h) + (1 / 2) * Real.log (w₀ - h) =
      Real.log (Real.sqrt (w₀ ^ 2 - h ^ 2)) ∧
    Real.sqrt (w₀ ^ 2 - h ^ 2) < w₀ ∧
    0 < w₀ - Real.sqrt (w₀ ^ 2 - h ^ 2) := by
  have hwph : (0 : ℝ) < w₀ + h := by linarith
  have hwmh : (0 : ℝ) < w₀ - h := by linarith
  have hdiff : (0 : ℝ) < w₀ ^ 2 - h ^ 2 := by nlinarith
  have hce_lt : Real.sqrt (w₀ ^ 2 - h ^ 2) < w₀ := by
    calc Real.sqrt (w₀ ^ 2 - h ^ 2)
        < Real.sqrt (w₀ ^ 2) := by
          exact Real.sqrt_lt_sqrt hdiff.le (by nlinarith)
      _ = w₀ := Real.sqrt_sq hw₀.le
  refine ⟨?_, hce_lt, by linarith⟩
  have key : (w₀ + h) * (w₀ - h) = w₀ ^ 2 - h ^ 2 := by ring
  rw [show (1 : ℝ) / 2 * Real.log (w₀ + h) + 1 / 2 * Real.log (w₀ - h) =
      1 / 2 * (Real.log (w₀ + h) + Real.log (w₀ - h)) from by ring,
      ← Real.log_mul hwph.ne' hwmh.ne', key, Real.log_sqrt hdiff.le]
  ring