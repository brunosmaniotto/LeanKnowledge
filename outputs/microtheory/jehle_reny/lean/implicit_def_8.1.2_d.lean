import Mathlib

noncomputable def expectedUtilityLow
    (u : ℝ → ℝ)       -- utility function
    (w L B p πl : ℝ)   -- wealth, loss, benefit, premium, low-risk probability
    : ℝ :=
  πl * u (w - L + B - p) + (1 - πl) * u (w - p)

noncomputable def expectedUtilityHigh
    (u : ℝ → ℝ)       -- utility function
    (w L B p πh : ℝ)   -- wealth, loss, benefit, premium, high-risk probability
    : ℝ :=
  πh * u (w - L + B - p) + (1 - πh) * u (w - p)