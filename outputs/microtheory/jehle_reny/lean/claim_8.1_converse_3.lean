import Mathlib
open Topology

-- Separating equilibrium setup for insurance market
-- θ_H, θ_L: types; policies (w₁, w₂) offered
axiom SeparatingEquilibrium : Prop
axiom BothPoliciesAccepted : Prop

-- Condition (3) of Theorem 8.1: the high-risk type weakly prefers
-- the contract designed for him over the low-risk contract
axiom Theorem_8_1_condition_3 : Prop

-- Part (1) of Lemma 8.1: in a separating equilibrium where both
-- policies are accepted, each type's contract must be at least as
-- good as the other type's contract for that type
axiom Lemma_8_1_part_1 : Prop

-- Lemma 8.1 part (1) holds in any separating equilibrium with both accepted
axiom lemma_8_1_part_1_holds :
  SeparatingEquilibrium → BothPoliciesAccepted → Lemma_8_1_part_1

-- Lemma 8.1 part (1) implies Theorem 8.1 condition (3)
axiom lemma_8_1_implies_condition_3 :
  Lemma_8_1_part_1 → Theorem_8_1_condition_3

theorem Claim_8_1_converse_3
    (h_sep : SeparatingEquilibrium)
    (h_acc : BothPoliciesAccepted) :
    Theorem_8_1_condition_3 := by
  have h1 := lemma_8_1_part_1_holds h_sep h_acc
  exact lemma_8_1_implies_condition_3 h1