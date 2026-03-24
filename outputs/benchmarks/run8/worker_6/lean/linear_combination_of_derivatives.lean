import Mathlib

theorem linear_combination_deriv {f g : ℝ → ℝ} {ξ : ℝ} (hf : DifferentiableAt ℝ f ξ) 
    (hg : DifferentiableAt ℝ g ξ) (c d : ℝ) :
    deriv (c • f + d • g) ξ = c * deriv f ξ + d * deriv g ξ := by
  have h1 : DifferentiableAt ℝ (c • f) ξ := hf.const_smul c
  have h2 : DifferentiableAt ℝ (d • g) ξ := hg.const_smul d
  calc
    deriv (c • f + d • g) ξ = deriv (c • f) ξ + deriv (d • g) ξ := deriv_add h1 h2
    _ = c • deriv f ξ + d • deriv g ξ := by rw [deriv_const_smul c hf, deriv_const_smul d hg]
    _ = c * deriv f ξ + d * deriv g ξ := by simp