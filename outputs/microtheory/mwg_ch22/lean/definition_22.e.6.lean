import Mathlib
open Topology

/-- A bargaining solution satisfies Individual Rationality (IR) if, after normalizing
    the threat point to 0, every agent receives a nonneg payoff: fᵢ(U) ≥ 0 for all i. -/
def IndividualRationality {n : ℕ} (f : Set (Fin n → ℝ) → (Fin n → ℝ)) : Prop :=
  ∀ (U : Set (Fin n → ℝ)) (i : Fin n), 0 ≤ f U i