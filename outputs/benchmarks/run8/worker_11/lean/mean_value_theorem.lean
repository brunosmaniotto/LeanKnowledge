import Mathlib

open Set

/-- The Mean Value Theorem: if `f` is continuous on `[a, b]` and differentiable on `(a, b)`,
    then there exists `ξ ∈ (a, b)` such that `f' ξ = (f b - f a) / (b - a)`. -/
theorem mean_value_theorem (a b : ℝ) (f : ℝ → ℝ) (hab : a < b)
    (hfcont : ContinuousOn f (Icc a b)) (hfdiff : DifferentiableOn ℝ f (Ioo a b)) :
    ∃ ξ ∈ Ioo a b, deriv f ξ = (f b - f a) / (b - a) :=
  exists_deriv_eq_slope f hab hfcont hfdiff