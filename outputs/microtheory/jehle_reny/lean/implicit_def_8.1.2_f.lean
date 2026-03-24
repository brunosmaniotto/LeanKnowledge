import Mathlib

noncomputable def zeroProfitLine (π : ℝ) : Set (ℝ × ℝ) :=
  {bp | bp.2 = π * bp.1}