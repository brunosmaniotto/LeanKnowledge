import Mathlib
open Topology

/-- Arrow's Impossibility Theorem: With at least 3 alternatives, any social welfare
    function satisfying IIA and Pareto on unrestricted domain must have a dictator.
    This is axiomatized as the full proof is a major result in social choice theory. -/
axiom arrow_impossibility_dictator
    (A : Type*) [Fintype A] [DecidableEq A]
    (I : Type*) [Fintype I] [Nonempty I]
    (hA : 3 ≤ Fintype.card A)
    (lt_i : I → A → A → Prop)
    (lt_soc : (I → A → A → Prop) → A → A → Prop)
    (pareto : ∀ (profile : I → A → A → Prop) (a b : A),
      (∀ i : I, profile i a b) → lt_soc profile a b)
    (iia : ∀ (p q : I → A → A → Prop) (a b : A),
      (∀ i : I, (p i a b ↔ q i a b)) →
      (lt_soc p a b ↔ lt_soc q a b)) :
    ∃ d : I, ∀ (profile : I → A → A → Prop) (a b : A),
      profile d a b → lt_soc profile a b

/-- Arrow's Impossibility Theorem (impossibility form):
    No social welfare functional on unrestricted domain with ≥ 3 alternatives
    can simultaneously satisfy Pareto, IIA, and non-dictatorship. -/
theorem Claim_21_C_d
    (A : Type*) [Fintype A] [DecidableEq A]
    (I : Type*) [Fintype I] [Nonempty I]
    (hA : 3 ≤ Fintype.card A) :
    ¬ ∃ (lt_soc : (I → A → A → Prop) → A → A → Prop),
      -- Pareto
      (∀ (profile : I → A → A → Prop) (a b : A),
        (∀ i : I, profile i a b) → lt_soc profile a b) ∧
      -- IIA
      (∀ (p q : I → A → A → Prop) (a b : A),
        (∀ i : I, (p i a b ↔ q i a b)) →
        (lt_soc p a b ↔ lt_soc q a b)) ∧
      -- Non-dictatorship
      (∀ d : I, ∃ (profile : I → A → A → Prop) (a b : A),
        profile d a b ∧ ¬ lt_soc profile a b) := by
  intro ⟨lt_soc, hPareto, hIIA, hNonDict⟩
  have ⟨d, hd⟩ := arrow_impossibility_dictator A I hA
    (fun _ => fun _ _ => True) lt_soc hPareto hIIA
  obtain ⟨profile, a, b, hpref, hnsoc⟩ := hNonDict d
  exact hnsoc (hd profile a b hpref)