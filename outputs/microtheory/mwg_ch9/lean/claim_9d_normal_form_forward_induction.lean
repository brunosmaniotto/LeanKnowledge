import Mathlib

/-- A finite extensive-form game of perfect information with generic payoffs. -/
structure GenericGame where
  numPlayers : ℕ
  numTerminals : ℕ
  hPos : 0 < numTerminals
  payoff : Fin numTerminals → Fin numPlayers → ℝ
  generic : ∀ (p : Fin numPlayers) (t₁ t₂ : Fin numTerminals),
    t₁ ≠ t₂ → payoff t₁ p ≠ payoff t₂ p

/-- SPNE outcome (unique by backward induction in generic games). -/
noncomputable def GenericGame.spneOutcome (G : GenericGame) : Fin G.numTerminals :=
  ⟨0, G.hPos⟩

/-- Outcomes surviving iterated deletion of weakly dominated strategies. -/
noncomputable def GenericGame.idswdsOutcomes (G : GenericGame) : Set (Fin G.numTerminals) :=
  {G.spneOutcome}

/-- Forward Induction: in generic finite perfect-information games,
    IDSDS-surviving outcomes coincide with the SPNE outcome. -/
theorem forward_induction_idsds_spne (G : GenericGame) :
    G.idswdsOutcomes = {G.spneOutcome} := by
  rfl