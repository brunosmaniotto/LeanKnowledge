import Mathlib

open BigOperators
open Finset
open Topology

-- Predicate for a consumer's budget constraint holding with equality
def BudgetConstraintHolds {n m : ℕ} (p : Fin n → ℝ) (x ω : Fin m → Fin n → ℝ) (i : Fin m) : Prop :=
  ∑ l : Fin n, p l * (x i l) = ∑ l : Fin n, p l * (ω i l)

-- Predicate for a market clearing (supply equals demand)