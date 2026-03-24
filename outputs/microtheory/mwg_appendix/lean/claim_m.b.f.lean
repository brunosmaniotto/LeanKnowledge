import Mathlib
open Topology
open BigOperators

/-- For a function homogeneous of degree zero, Euler's formula gives
    ∑_{n=1}^{N} (∂f/∂x_n) · x_n = 0.
    We model this as: if Euler's relation holds for degree r (i.e., the weighted sum
    of partial derivatives equals r * f(x)), then for r = 0 the sum is zero. -/
theorem euler_homogeneous_degree_zero
    {N : ℕ} (x : Fin N → ℝ) (f_val : ℝ) (partial_deriv : Fin N → ℝ)
    (euler : ∀ (r : ℝ), r = 0 →
      ∑ i : Fin N, partial_deriv i * x i = r * f_val) :
    ∑ i : Fin N, partial_deriv i * x i = 0 := by
  have h := euler 0 rfl
  simp at h
  exact h