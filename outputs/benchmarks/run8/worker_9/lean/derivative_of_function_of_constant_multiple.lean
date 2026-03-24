import Mathlib

theorem derivative_of_constant_multiple (f : ℝ → ℝ) (c : ℝ) (x : ℝ) (hf : Differentiable ℝ f) :
    HasDerivAt (fun t => f (c * t)) (c * deriv f (c * x)) x := by
  -- Derivative of the inner function g(t) = c * t at x is c
  have hg : HasDerivAt (fun t : ℝ => c * t) c x := by
    simpa only [mul_one] using (hasDerivAt_id x).const_mul c
  -- f is differentiable at (c * x) because it's differentiable everywhere
  have hf' : HasDerivAt f (deriv f (c * x)) (c * x) := (hf (c * x)).hasDerivAt
  -- Chain rule: derivative of f ∘ g at x is (deriv f (c * x)) * c
  have H : HasDerivAt (fun t => f (c * t)) (deriv f (c * x) * c) x :=
    HasDerivAt.comp x hf' hg
  -- Rewrite to c * deriv f (c * x) to match the goal
  rw [mul_comm] at H
  exact H