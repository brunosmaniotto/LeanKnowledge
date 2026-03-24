import Mathlib

/-- Short-run supply and variable input demands are homogeneous of degree zero in (p, w):
    scaling both prices by α > 0 preserves the profit-maximizing choice. -/
theorem shortRun_supply_and_variable_demand_homogeneous_deg_zero
    {Z : Type*}
    (f : Z → ℝ)
    (cost : Z → ℝ)
    (p w : ℝ)
    (α : ℝ) (hα : α > 0)
    (z_star : Z)
    (hopt : ∀ z : Z, p * f z - w * cost z ≤ p * f z_star - w * cost z_star) :
    ∀ z : Z, (α * p) * f z - (α * w) * cost z ≤
      (α * p) * f z_star - (α * w) * cost z_star := by
  intro z
  have hz := hopt z
  nlinarith