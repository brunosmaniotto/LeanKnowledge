import Mathlib

open BigOperators Finset
open Topology

/-- Envelope theorem for cost minimization: dc/dy = ∂sc/∂y when ∂sc/∂x̄ᵢ = 0 at optimum.
    We model sc as a function of (y, x̄) where x̄ : Fin n → ℝ depends on y.
    The chain rule gives dc/dy = ∂sc/∂y + Σᵢ (∂sc/∂x̄ᵢ)(dx̄ᵢ/dy).
    The FOC ∂sc/∂x̄ᵢ = 0 kills the sum, yielding dc/dy = ∂sc/∂y. -/
theorem envelope_cost_derivative
    {n : ℕ}
    (sc : ℝ → (Fin n → ℝ) → ℝ)       -- short-run cost sc(y, x̄)
    (x_bar : ℝ → Fin n → ℝ)            -- optimal fixed inputs x̄(y)
    (y : ℝ)
    (dc_dy : ℝ)                         -- derivative of long-run cost
    (dsc_dy : ℝ)                        -- partial derivative ∂sc/∂y
    (dsc_dx : Fin n → ℝ)               -- partial derivatives ∂sc/∂x̄ᵢ
    (dx_bar_dy : Fin n → ℝ)            -- derivatives dx̄ᵢ/dy
    -- c(y) = sc(y, x̄(y)) has derivative dc_dy
    (h_deriv_c : HasDerivAt (fun y' => sc y' (x_bar y')) dc_dy y)
    -- The chain rule decomposition: dc/dy = ∂sc/∂y + Σᵢ (∂sc/∂x̄ᵢ)(dx̄ᵢ/dy)
    (h_chain : dc_dy = dsc_dy + ∑ i : Fin n, dsc_dx i * dx_bar_dy i)
    -- FOC: ∂sc/∂x̄ᵢ = 0 for all i at the optimum
    (h_foc : ∀ i : Fin n, dsc_dx i = 0) :
    dc_dy = dsc_dy := by
  rw [h_chain]
  simp only [h_foc, zero_mul, sum_const_zero, add_zero]