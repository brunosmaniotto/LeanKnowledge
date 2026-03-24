import Mathlib

open BigOperators Finset
open Topology

/-- Expected utility for player `i` playing pure strategy `si` when opponents
    play mixed strategies `σ`. Only opponents' components of `σ` are used. -/
noncomputable def expectedUtility
    {I : Type*} [Fintype I] [DecidableEq I]
    {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]
    (u : (i : I) → ((j : I) → S j) → ℝ)
    (σ : (j : I) → S j → ℝ)
    (i : I) (si : S i) : ℝ :=
  ∑ f : (j : I) → S j,
    (∏ j ∈ Finset.univ.erase i, σ j (f j)) *
    u i (Function.update f i si)

/-- Two games with the same player set and strategy sets are **strategically
    equivalent** if for every player `i` and every valid mixed-strategy profile
    of the opponents, player `i`'s ranking of pure strategies is identical
    in both games. -/
def StrategicallyEquivalent
    {I : Type*} [Fintype I] [DecidableEq I]
    {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]
    (u₁ u₂ : (i : I) → ((j : I) → S j) → ℝ) : Prop :=
  ∀ (i : I) (a b : S i) (σ : (j : I) → S j → ℝ),
    (∀ j, ∀ s : S j, 0 ≤ σ j s) →
    (∀ j, j ≠ i → ∑ s : S j, σ j s = 1) →
    (expectedUtility u₁ σ i a ≤ expectedUtility u₁ σ i b ↔
     expectedUtility u₂ σ i a ≤ expectedUtility u₂ σ i b)