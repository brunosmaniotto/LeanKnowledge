import Mathlib
open Topology

/-- In a separating equilibrium with two types, each type must weakly prefer
    their own equilibrium action to mimicking the other type's action. -/
theorem claim_8_1_2_m
    {RiskType : Type} [DecidableEq RiskType]
    (t₁ t₂ : RiskType)
    (h_diff : t₁ ≠ t₂)
    (u : RiskType → RiskType → ℝ)
    (ic₁ : u t₁ t₁ ≥ u t₁ t₂)
    (ic₂ : u t₂ t₂ ≥ u t₂ t₁) :
    (u t₁ t₁ ≥ u t₁ t₂) ∧ (u t₂ t₂ ≥ u t₂ t₁) := by
  exact ⟨ic₁, ic₂⟩