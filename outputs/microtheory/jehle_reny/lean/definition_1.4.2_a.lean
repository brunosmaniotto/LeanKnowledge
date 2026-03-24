import Mathlib

/-- An isoexpenditure curve at prices (p₁, p₂) and expenditure level e
    is the set of all bundles x = (x₁, x₂) such that p₁·x₁ + p₂·x₂ = e. -/
def isoexpenditureCurve (p₁ p₂ e : ℝ) : Set (ℝ × ℝ) :=
  {x | p₁ * x.1 + p₂ * x.2 = e}

/-- Slope of the isoexpenditure curve: -p₁/p₂. -/
noncomputable def isoexpenditureSlope (p₁ p₂ : ℝ) : ℝ := -p₁ / p₂

/-- Horizontal intercept of the isoexpenditure curve: e/p₁. -/
noncomputable def isoexpenditureHIntercept (p₁ e : ℝ) : ℝ := e / p₁

/-- Vertical intercept of the isoexpenditure curve: e/p₂. -/
noncomputable def isoexpenditureVIntercept (p₂ e : ℝ) : ℝ := e / p₂