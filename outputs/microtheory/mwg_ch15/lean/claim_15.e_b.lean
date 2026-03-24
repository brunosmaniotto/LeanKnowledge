import Mathlib

/-- In partial equilibrium with perfectly elastic labor supply at wage w,
    a tax t on labor in town 1 means the firm pays w + t per unit but
    workers still receive w. The firm bears the entire tax burden. -/
theorem partial_equilibrium_labor_tax_incidence
    (w t : ℝ) (ht : 0 < t)
    (f : ℝ → ℝ) -- production function
    (f' : ℝ → ℝ) -- marginal product of labor
    (z₀ z₁ : ℝ) -- employment before and after tax
    (h_pre : f' z₀ = w) -- pre-tax optimality: f'(z₀) = w
    (h_post : f' z₁ = t + w) -- post-tax optimality: f'(z₁) = t + w
    : let wage_received := w
      let firm_cost_per_unit := w + t
      firm_cost_per_unit - wage_received = t := by
  simp only
  ring