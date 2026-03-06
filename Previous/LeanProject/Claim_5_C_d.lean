import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Data.Real.Basic

open BigOperators

/-- Claim 5.C.d: First-order conditions for the PMP with a transformation function.
    If y maximizes p · y subject to F(y) ≤ 0, and F is differentiable at y,
    then p is proportional to the gradient of F at y (the fderiv). -/
theorem pmp_foc {L : ℕ} (p : Fin L → ℝ) (F : (Fin L → ℝ) → ℝ) (y : Fin L → ℝ)
    (h_diff : DifferentiableAt ℝ F y)
    (h_max : ∀ y', F y' ≤ 0 → (∑ i, p i * y' i) ≤ (∑ i, p i * y i))
    (h_bound : F y = 0) :
    ∃ λ ≥ (0 : ℝ), ∀ v, (∑ i, p i * v i) = λ * (fderiv ℝ F y v) := sorry
