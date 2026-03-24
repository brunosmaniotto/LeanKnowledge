import Mathlib

structure HybridModel where
  g : ℝ → ℝ
  π : ℝ → ℝ → ℝ
  e_hat : ℝ → ℝ → ℝ
  e_hat_inv : ∀ (profit θ : ℝ), π (e_hat profit θ) θ = profit

noncomputable def HybridModel.g_hat (M : HybridModel) (profit θ : ℝ) : ℝ :=
  M.g (M.e_hat profit θ)

def HybridModel.pi_tilde (_M : HybridModel) (profit : ℝ) : ℝ := profit