import Mathlib

/-- A function f : ℝ → ℝ is continuous at x₀ if for every ε > 0 there exists δ > 0
    such that |x - x₀| < δ implies |f(x) - f(x₀)| < ε. -/
abbrev MWG.IsContinuousAt (f : ℝ → ℝ) (x₀ : ℝ) : Prop :=
  ContinuousAt f x₀

/-- A function f : ℝ → ℝ is continuous if it is continuous at every point. -/
abbrev MWG.IsContinuousOn (f : ℝ → ℝ) : Prop :=
  Continuous f