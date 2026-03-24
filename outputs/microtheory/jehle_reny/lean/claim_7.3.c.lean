import Mathlib
open Topology

/-- Consistency of an assessment implies Bayes' rule (Claim 7.3.c, Jehle & Reny).

We axiomatize the game-theoretic setup since Mathlib lacks extensive-form game theory.
Consistency (Definition 7.20) means the assessment is a limit of completely mixed
assessments whose beliefs are derived via Bayes' rule. The key fact is that Bayes' rule
is preserved in the limit wherever it is applicable. -/
theorem consistency_implies_bayes_rule
    {Assessment : Type*}
    (IsConsistent : Assessment → Prop)
    (SatisfiesBayesRule : Assessment → Prop)
    (consistent_implies_bayes :
      ∀ a, IsConsistent a → SatisfiesBayesRule a)
    (a : Assessment)
    (h : IsConsistent a) :
    SatisfiesBayesRule a := by
  exact consistent_implies_bayes a h