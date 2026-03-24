import Mathlib

noncomputable def commonIntegralFunction (f : ℝ → ℝ) (a b : ℝ) : ℝ :=
  ∫ x in a..b, f x