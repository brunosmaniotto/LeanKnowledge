import Mathlib

theorem Exercise_4_26_e
    (u : ℝ → ℝ → ℝ)
    (p w t x_tax x_ls T : ℝ)
    (ht : t > 0)
    (hx_tax : x_tax > 0)
    (hT : T = t * x_tax)
    -- Under per-unit tax, consumer chooses x_tax and pays (p+t)*x_tax out of wealth w
    -- The same basket under lump-sum tax T costs p*x_tax + T (algebraically equal)
    (h_equal_cost : (p + t) * x_tax = p * x_tax + T)
    -- Under lump-sum tax, consumer optimizes at undistorted price p with wealth w - T
    -- so x_ls is at least as good as x_tax at those prices
    (h_opt : u x_ls (w - T - p * x_ls) ≥ u x_tax (w - T - p * x_tax))
    : u x_ls (w - T - p * x_ls) ≥ u x_tax (w - (p + t) * x_tax) := by
  have key : w - (p + t) * x_tax = w - T - p * x_tax := by
    rw [h_equal_cost]; ring
  rw [key]
  exact h_opt