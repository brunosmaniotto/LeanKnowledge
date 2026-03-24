import Mathlib

open Real

theorem deriv_arccos_eq (x : ℝ) (h : x ∈ Set.Ioo (-1 : ℝ) 1) :
    deriv arccos x = -1 / Real.sqrt (1 - x ^ 2) := by
  obtain ⟨hx_left, hx_right⟩ := h
  have h1 : x ≠ -1 := by linarith
  have h2 : x ≠ 1 := by linarith
  have H : HasDerivAt arccos (-(1 / Real.sqrt (1 - x ^ 2))) x :=
    Real.hasDerivAt_arccos h1 h2
  -- Convert HasDerivAt to deriv, and rewrite the derivative expression
  rw [H.deriv]
  rw [neg_div]