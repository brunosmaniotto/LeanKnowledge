import Mathlib
open Topology
open BigOperators

noncomputable section

/-- Elasticity of scale: μ(x) = Df(x)(x) / f(x) = (∑ᵢ fᵢ(x)·xᵢ) / f(x) -/
def elasticityOfScale {n : ℕ} (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) : ℝ :=
  (fderiv ℝ f x) x / f x