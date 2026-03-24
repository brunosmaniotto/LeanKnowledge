import Mathlib

noncomputable section

theorem relative_risk_aversion_proportional
    (u : ℝ → ℝ) (x : ℝ) (hx : x ≠ 0)
    (hu : ∀ y, DifferentiableAt ℝ u y)
    (hu' : ∀ y, DifferentiableAt ℝ (deriv u) y)
    (hu'_ne : deriv u x ≠ 0)
    : -(deriv (deriv u) x * x ^ 2) / (deriv u x * x) =
      -(x * deriv (deriv u) x) / deriv u x := by
  field_simp [hx, hu'_ne]