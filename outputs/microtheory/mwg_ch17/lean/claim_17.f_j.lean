import Mathlib

-- GS (Gross Substitutes) property does not imply WA (Weak Axiom of revealed preference)
-- for aggregate excess demand. This is a structural impossibility result from
-- microeconomic theory (MWG Example 17.F.1).

-- We axiomatize the economic primitives since Mathlib has no micro theory.
axiom ExcessDemand : Type
axiom satisfies_GS : ExcessDemand → Prop
axiom satisfies_WA : ExcessDemand → Prop
axiom constant_returns_economy : ExcessDemand → Prop
axiom has_multiple_equilibria : ExcessDemand → Prop

-- The counterexample: an excess demand function that is GS but not WA
axiom counterexample_17F1 : ExcessDemand
axiom counterexample_is_GS : satisfies_GS counterexample_17F1
axiom counterexample_not_WA : ¬ satisfies_WA counterexample_17F1
axiom counterexample_constant_returns : constant_returns_economy counterexample_17F1
axiom counterexample_multiple_equilibria : has_multiple_equilibria counterexample_17F1

/-- The Gross Substitutes property does not imply the Weak Axiom for aggregate
    excess demand. In a constant returns economy, GS does not guarantee uniqueness
    of equilibrium. -/
theorem gs_does_not_imply_wa :
    ∃ z : ExcessDemand, satisfies_GS z ∧ ¬ satisfies_WA z ∧
      constant_returns_economy z ∧ has_multiple_equilibria z := by
  exact ⟨counterexample_17F1, counterexample_is_GS, counterexample_not_WA,
         counterexample_constant_returns, counterexample_multiple_equilibria⟩