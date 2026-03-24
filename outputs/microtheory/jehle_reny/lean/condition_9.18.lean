import Mathlib

noncomputable section

def virtualValuation (F f : ℝ → ℝ) (v : ℝ) : ℝ :=
  v - (1 - F v) / f v