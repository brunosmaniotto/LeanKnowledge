import Mathlib

open Finset
open BigOperators
open Topology

variable {Node : Type} [Fintype Node] [DecidableEq Node]
variable {InfoSet : Type} [Fintype InfoSet] [DecidableEq InfoSet]
variable (I : Node → InfoSet)
variable (nodes_of : InfoSet → Finset Node)
variable (BehavioralStrategy : Type)
variable (reach_prob : BehavioralStrategy → Node → ℝ)

-- Axiom: every node belongs to its assigned information set
axiom node_in_info_set (x : Node) : x ∈ nodes_of (I x)

-- Axiom: reach probabilities are nonnegative
axiom reach_prob_nonneg (b : BehavioralStrategy) (x : Node) : 0 ≤ reach_prob b x

theorem Claim_7_3_7_c (b : BehavioralStrategy) (s : InfoSet) (h : 0 < ∑ y ∈ nodes_of s, reach_prob b y) :
    ∑ x ∈ nodes_of s, (reach_prob b x / ∑ y ∈ nodes_of s, reach_prob b y) = 1 := by
  calc
    ∑ x ∈ nodes_of s, (reach_prob b x / ∑ y ∈ nodes_of s, reach_prob b y) 
        = (∑ x ∈ nodes_of s, reach_prob b x) / ∑ y ∈ nodes_of s, reach_prob b y := by rw [← Finset.sum_div]
    _ = (∑ y ∈ nodes_of s, reach_prob b y) / ∑ y ∈ nodes_of s, reach_prob b y := by rfl
    _ = 1 := div_self (ne_of_gt h)