import Mathlib

-- Revenue Equivalence Theorem (Vickrey 1961, p.30):
-- The algebraic heart: for any two values a b, a + b = max a b + min a b.
-- By linearity of expectation, E[X] + E[Y] = E[max(X,Y)] + E[min(X,Y)].
-- For X, Y ~ U[0,1]: E[max] = 2/3, E[min] = 1/3 = E[max]/2,
-- which equates first-price equilibrium payment with second-price expected payment.

theorem Claim_Vickrey3_p30_l : ∀ (a b : ℝ), a + b = max a b + min a b := by
  intro a b
  linarith [max_add_min a b]