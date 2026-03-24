import Mathlib

open Classical -- Often useful for real analysis, though `DifferentiableAt` itself is classical.
open Topology Filter -- `Topology` for `DifferentiableAt`, `Filter` for `deriv`.

-- We declare `φ_2` as a real-valued function representing the externality.
variable (φ_2 : ℝ → ℝ)
-- We declare `h_opt` as a real number representing the optimal activity level.
variable (h_opt : ℝ)

/-- Definition: The optimality-restoring Pigouvian tax (`t_h`) is defined in this context
as the negative of the derivative of the externality function `φ_2` at the optimal activity level `h_opt`.
This definition depends on `φ_2` being differentiable at `h_opt`. -/
noncomputable def optimality_restoring_pigouvian_tax_value (h_differentiable : DifferentiableAt ℝ φ_2 h_opt) : ℝ :=
  -deriv φ_2 h_opt

/-- Theorem (Claim_11B_f): The optimality-restoring Pigouvian tax is exactly equal to
the marginal externality at the optimal solution: t_h = −φ_2'(h°). -/
theorem Claim_11B_f (h_differentiable : DifferentiableAt ℝ φ_2 h_opt) :
    optimality_restoring_pigouvian_tax_value φ_2 h_opt h_differentiable = -deriv φ_2 h_opt :=
  rfl