import Mathlib

/-- A function f : ℝ → ℝ is differentiable if it is differentiable at every point,
    i.e., continuous and 'smooth' with no breaks or kinks.
    (MWG Implicit Definition A2.1.1a) -/
def E.utility_differentiable (f : ℝ → ℝ) : Prop :=
  Differentiable ℝ f