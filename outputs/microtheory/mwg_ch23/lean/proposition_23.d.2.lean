import Mathlib

open MeasureTheory Set

/-- Bayesian SCF with expected valuation, utility, and transfer functions -/
structure BayesianSCF (I : ℕ) where
  v_bar : Fin I → ℝ → ℝ
  U : Fin I → ℝ → ℝ
  t_bar : Fin I → ℝ → ℝ
  θ_L : ℝ

def BayesianIC (scf : BayesianSCF I) : Prop :=
  ∀ i : Fin I, ∀ θ_i θ_hat : ℝ,
    scf.U i θ_i ≥ θ_i * scf.v_bar i θ_hat + scf.t_bar i θ_hat