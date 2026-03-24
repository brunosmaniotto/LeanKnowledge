import Mathlib
open Topology

/-- The marginal product of input `i` for production function `f` at input vector `z`.
    Defined as the partial derivative ∂f(z)/∂zᵢ, giving the rate at which output
    changes per additional unit of input i employed. -/
noncomputable def marginalProduct
    {n : ℕ} (f : (Fin n → ℝ) → ℝ) (z : Fin n → ℝ) (i : Fin n) : ℝ :=
  fderiv ℝ f z (Pi.single i 1)