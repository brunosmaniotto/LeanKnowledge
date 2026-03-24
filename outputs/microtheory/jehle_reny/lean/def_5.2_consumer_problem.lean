import Mathlib

open BigOperators Finset
open Topology

def ConsumerBudgetSet {n : ℕ} (p e : Fin n → ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ k, 0 ≤ x k) ∧ ∑ k, p k * x k ≤ ∑ k, p k * e k}