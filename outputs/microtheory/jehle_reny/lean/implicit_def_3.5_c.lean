import Mathlib

open scoped BigOperators
open Topology

/-- The marginal revenue product of input `i`: the output price `p` times
    the partial derivative ∂f(x)/∂x_i. -/
noncomputable def marginalRevenueProduct
    {n : ℕ} (p : ℝ) (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) (i : Fin n) : ℝ :=
  p * fderiv ℝ f x (Pi.single i 1)