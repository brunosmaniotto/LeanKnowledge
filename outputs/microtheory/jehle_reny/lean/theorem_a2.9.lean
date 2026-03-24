import Mathlib
open Topology

/-- First-Order Necessary Condition: If f is differentiable and x* is a local
    interior maximum or minimum, then ∇f(x*) = 0. -/
theorem Theorem_A2_9 {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (x : EuclideanSpace ℝ (Fin n))
    (hd : DifferentiableAt ℝ f x)
    (hext : IsLocalMin f x ∨ IsLocalMax f x) :
    fderiv ℝ f x = 0 := by
  rcases hext with h | h
  · exact h.hasFDerivAt_eq_zero hd.hasFDerivAt
  · exact h.hasFDerivAt_eq_zero hd.hasFDerivAt