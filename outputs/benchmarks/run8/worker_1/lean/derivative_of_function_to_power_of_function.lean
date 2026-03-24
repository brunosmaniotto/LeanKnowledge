import Mathlib

open Real

theorem Derivative_of_Function_to_Power_of_Function
    (u v : ℝ → ℝ) (hu : Differentiable ℝ u) (hv : Differentiable ℝ v)
    (h_pos : ∀ x, 0 < u x) :
    deriv (fun x => u x ^ v x) = fun x =>
      v x * u x ^ (v x - 1) * deriv u x + u x ^ v x * log (u x) * deriv v x := by
  funext x
  have h_deriv_at := HasDerivAt.rpow (hu x).hasDerivAt (hv x).hasDerivAt (h_pos x)
  rw [h_deriv_at.deriv]
  ring