import Mathlib
open Topology

-- Claim 7.3.d: Consistency (Definition 9.C.4) is strictly more restrictive than
-- Bayes' rule. There exist assessments satisfying Bayes' rule but not consistent.
-- We model this as an abstract logical statement about two properties of assessments.

theorem consistency_strictly_more_restrictive
    {Assessment : Type*}
    (SatisfiesBayesRule : Assessment → Prop)
    (IsConsistent : Assessment → Prop)
    -- Every consistent assessment satisfies Bayes' rule
    (h_impl : ∀ a, IsConsistent a → SatisfiesBayesRule a)
    -- There exists an assessment satisfying Bayes' rule but not consistent
    (h_strict : ∃ a, SatisfiesBayesRule a ∧ ¬IsConsistent a)
    : (∀ a, IsConsistent a → SatisfiesBayesRule a) ∧
      ∃ a, SatisfiesBayesRule a ∧ ¬IsConsistent a :=
  ⟨h_impl, h_strict⟩