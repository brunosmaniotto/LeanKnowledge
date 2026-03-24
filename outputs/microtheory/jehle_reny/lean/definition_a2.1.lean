import Mathlib
open Topology

noncomputable section
variable {n : ℕ}

/-- The partial derivative of f : ℝⁿ → ℝ with respect to xᵢ at x, defined as
    ∂f(x)/∂xᵢ = lim_{h→0} [f(x₁,...,xᵢ+h,...,xₙ) - f(x₁,...,xᵢ,...,xₙ)] / h. -/
def MWG.partialDeriv (f : (Fin n → ℝ) → ℝ) (i : Fin n) (x : Fin n → ℝ) : ℝ :=
  deriv (fun t => f (Function.update x i t)) (x i)