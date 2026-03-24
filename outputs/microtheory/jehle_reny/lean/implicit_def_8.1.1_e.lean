import Mathlib

open BigOperators Finset
open Topology

/-- An allocation assigns wealth to each consumer and each insurance company in each state. -/
structure Allocation (I K S : Type*) [Fintype I] [Fintype K] [Fintype S] where
  /-- Wealth assigned to consumer i in state s -/
  consumer : I → S → ℝ
  /-- Wealth assigned to insurance company k in state s -/
  insurer : K → S → ℝ

/-- An allocation is feasible if in every state the total wealth assigned equals
    the total consumer endowment. -/
def Allocation.IsFeasible {I K S : Type*} [Fintype I] [Fintype K] [Fintype S]
    (a : Allocation I K S) (endowment : I → S → ℝ) : Prop :=
  ∀ s : S,
    (∑ i : I, a.consumer i s) + (∑ k : K, a.insurer k s) =
      ∑ i : I, endowment i s