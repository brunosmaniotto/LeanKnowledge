import Mathlib

open BigOperators Finset Filter Topology
open Topology

noncomputable section

structure InfiniteHorizonEconomy where
  price : ℕ → ℝ
  consumption : ℕ → ℝ
  wealth : ℝ
  discount : ℝ
  u : ℝ → ℝ
  discount_pos : 0 < discount
  discount_lt_one : discount < 1
  wealth_pos : 0 < wealth
  budget_binds : HasSum (fun t => price t * consumption t) wealth
  foc : ∃ lam : ℝ, lam > 0 ∧ ∀ t : ℕ, ∃ du : ℝ, lam * price t = discount ^ t * du

def IsBudgetFeasible (E : InfiniteHorizonEconomy) (c' : ℕ → ℝ) : Prop :=
  ∃ s : ℝ, s ≤ E.wealth ∧ HasSum (fun t => E.price t * c' t) s