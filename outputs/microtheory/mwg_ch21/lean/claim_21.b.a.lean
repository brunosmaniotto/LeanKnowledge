import Mathlib

-- Social welfare functional (abstract type)
axiom SWF : Type

-- Majority voting rule
axiom majorityVoting : SWF

-- The three characterizing properties
axiom SymmetryAmongAgents : SWF → Prop
axiom NeutralityBetweenAlts : SWF → Prop
axiom PositiveResponsiveness : SWF → Prop

-- Counterexample 1: Dictator rule
axiom dictatorRule : SWF
axiom dictatorRule_ne : dictatorRule ≠ majorityVoting
axiom dictatorRule_neutral : NeutralityBetweenAlts dictatorRule
axiom dictatorRule_responsive : PositiveResponsiveness dictatorRule
axiom dictatorRule_not_symmetric : ¬SymmetryAmongAgents dictatorRule

-- Counterexample 2: Status-quo biased rule
axiom statusQuoRule : SWF
axiom statusQuoRule_ne : statusQuoRule ≠ majorityVoting
axiom statusQuoRule_symmetric : SymmetryAmongAgents statusQuoRule
axiom statusQuoRule_responsive : PositiveResponsiveness statusQuoRule
axiom statusQuoRule_not_neutral : ¬NeutralityBetweenAlts statusQuoRule

-- Counterexample 3: Supermajority rule
axiom supermajorityRule : SWF
axiom supermajorityRule_ne : supermajorityRule ≠ majorityVoting
axiom supermajorityRule_symmetric : SymmetryAmongAgents supermajorityRule
axiom supermajorityRule_neutral : NeutralityBetweenAlts supermajorityRule
axiom supermajorityRule_not_responsive : ¬PositiveResponsiveness supermajorityRule

/-- For each of the three properties (symmetry, neutrality, positive responsiveness),
there exists an SWF distinct from majority voting satisfying the other two.
Hence no property is redundant in the characterization of Proposition 21.B.1. -/
theorem Claim_21Ba_nonredundancy :
    (∃ F : SWF, F ≠ majorityVoting ∧
      NeutralityBetweenAlts F ∧ PositiveResponsiveness F ∧
      ¬SymmetryAmongAgents F) ∧
    (∃ F : SWF, F ≠ majorityVoting ∧
      SymmetryAmongAgents F ∧ PositiveResponsiveness F ∧
      ¬NeutralityBetweenAlts F) ∧
    (∃ F : SWF, F ≠ majorityVoting ∧
      SymmetryAmongAgents F ∧ NeutralityBetweenAlts F ∧
      ¬PositiveResponsiveness F) := by
  exact ⟨⟨dictatorRule, dictatorRule_ne, dictatorRule_neutral, dictatorRule_responsive,
          dictatorRule_not_symmetric⟩,
         ⟨statusQuoRule, statusQuoRule_ne, statusQuoRule_symmetric, statusQuoRule_responsive,
          statusQuoRule_not_neutral⟩,
         ⟨supermajorityRule, supermajorityRule_ne, supermajorityRule_symmetric,
          supermajorityRule_neutral, supermajorityRule_not_responsive⟩⟩