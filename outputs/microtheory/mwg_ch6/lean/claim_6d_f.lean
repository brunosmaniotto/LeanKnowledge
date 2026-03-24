import Mathlib

noncomputable section

open MeasureTheory Set

def intCDF (F : ℝ → ℝ) (x : ℝ) : ℝ := ∫ t in Icc 0 x, F t