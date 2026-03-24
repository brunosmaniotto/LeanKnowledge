import Mathlib

noncomputable section

variable (C AC C' : ℝ → ℝ) (q_bar : ℝ)

def profit (p q : ℝ) : ℝ := p * q - C q