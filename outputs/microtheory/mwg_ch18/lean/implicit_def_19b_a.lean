import Mathlib
open Topology

/-- A consumer in a contingent commodity economy.
    L = number of commodities, S = number of states of the world. -/
structure ContingentConsumer (L S : ℕ) where
  /-- Endowment vector ω_i ∈ ℝ^(L*S), indexed as (commodity, state) -/
  endowment : Fin L → Fin S → ℝ
  /-- Consumption set X_i ⊂ ℝ^(L*S) -/
  consumptionSet : Set (Fin L → Fin S → ℝ)
  /-- The endowment belongs to the consumption set -/
  endowment_mem : endowment ∈ consumptionSet
  /-- Ex ante rational preference relation ≿_i on contingent commodity vectors -/
  preference : (Fin L → Fin S → ℝ) → (Fin L → Fin S → ℝ) → Prop
  /-- Preferences are reflexive -/
  pref_refl : ∀ x ∈ consumptionSet, preference x x
  /-- Preferences are transitive -/
  pref_trans : ∀ x y z, x ∈ consumptionSet → y ∈ consumptionSet →
    z ∈ consumptionSet → preference x y → preference y z → preference x z
  /-- Preferences are complete on the consumption set -/
  pref_complete : ∀ x y, x ∈ consumptionSet → y ∈ consumptionSet →
    preference x y ∨ preference y x

namespace ContingentConsumer

/-- The endowment vector in state s -/
def stateEndowment {L S : ℕ} (c : ContingentConsumer L S) (s : Fin S) : Fin L → ℝ :=
  fun l => c.endowment l s

end ContingentConsumer