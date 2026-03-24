import Mathlib
open Topology

noncomputable section

/-- The contract curve in an Edgeworth box is the locus of feasible allocations
    where the two consumers' indifference curves are tangent to each other,
    i.e., the gradients of their utility functions are proportional.
    At any allocation off the contract curve, the indifference curves cross. -/
def contractCurve {n : ℕ} (u₁ u₂ : (Fin n → ℝ) → ℝ) (ω : Fin n → ℝ) :
    Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i ∧ x i ≤ ω i) ∧
       ∃ c : ℝ, c > 0 ∧ fderiv ℝ u₁ x = c • fderiv ℝ u₂ (ω - x)}