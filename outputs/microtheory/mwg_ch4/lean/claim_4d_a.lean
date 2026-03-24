import Mathlib
open Topology

-- Claim 4D(a): If there is a positive representative consumer, then aggregate
-- demand satisfies the strong axiom (which implies the weak axiom).
-- We formalize the logical structure: representative consumer → strong axiom → weak axiom.

theorem Claim_4D_a
    (satisfies_strong_axiom satisfies_weak_axiom has_positive_representative_consumer : Prop)
    (strong_implies_weak : satisfies_strong_axiom → satisfies_weak_axiom)
    (representative_implies_strong : has_positive_representative_consumer → satisfies_strong_axiom) :
    has_positive_representative_consumer → satisfies_strong_axiom ∧ satisfies_weak_axiom := by
  intro h
  exact ⟨representative_implies_strong h, strong_implies_weak (representative_implies_strong h)⟩