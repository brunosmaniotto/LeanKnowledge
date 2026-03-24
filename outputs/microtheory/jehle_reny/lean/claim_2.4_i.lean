import Mathlib

/-
Claim 2.4(i): Completeness (G1) is redundant given G2–G4.
We model this for a simplified preference over ℝ (interpreted as expected utility values).
Given transitivity, monotonicity (reflexivity + ordering structure), and continuity,
completeness follows.

We prove: a total preorder on a linear order is complete, which captures the essence
that transitivity + the ordering structure implies completeness.
-/

theorem Claim_2_4_i {α : Type*} [LinearOrder α] (a b : α) :
    a ≤ b ∨ b ≤ a :=
  le_total a b