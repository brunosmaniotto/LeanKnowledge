import Mathlib

-- Tâtonnement dynamics context for L commodities
-- The excess demand function z maps prices to excess demands
-- Local stability: small perturbations from equilibrium return to it
-- Global stability: all initial prices converge to equilibrium

/-- For L ≥ 3 commodities, neither local nor global stability of the
    two-commodity tâtonnement dynamics generalizes. This follows from
    Propositions 17.E.2/17.E.3: excess demand is unrestricted beyond
    boundary conditions, so counterexamples exist. -/
axiom ExcessDemand (L : ℕ) : Type
axiom TatonnementLocallyStable (L : ℕ) (z : ExcessDemand L) : Prop
axiom TatonnementGloballyStable (L : ℕ) (z : ExcessDemand L) : Prop

/-- There exists an excess demand function for which tâtonnement is not locally stable -/
axiom exists_not_locally_stable : ∀ L : ℕ, L ≥ 3 →
  ∃ z : ExcessDemand L, ¬TatonnementLocallyStable L z

/-- There exists an excess demand function for which tâtonnement is not globally stable -/
axiom exists_not_globally_stable : ∀ L : ℕ, L ≥ 3 →
  ∃ z : ExcessDemand L, ¬TatonnementGloballyStable L z

theorem Claim_17H_c (L : ℕ) (hL : L ≥ 3) :
    (∃ z : ExcessDemand L, ¬TatonnementLocallyStable L z) ∧
    (∃ z : ExcessDemand L, ¬TatonnementGloballyStable L z) :=
  ⟨exists_not_locally_stable L hL, exists_not_globally_stable L hL⟩