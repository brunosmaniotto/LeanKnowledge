import Mathlib

theorem product_rule {j k f : ℝ → ℝ} {ξ : ℝ} (hj : DifferentiableAt ℝ j ξ) (hk : DifferentiableAt ℝ k ξ)
    (hf : ∀ x, f x = j x * k x) : deriv f ξ = j ξ * deriv k ξ + deriv j ξ * k ξ := by
  have h_eq : f = j * k := funext hf
  rw [h_eq, deriv_mul hj hk, add_comm]