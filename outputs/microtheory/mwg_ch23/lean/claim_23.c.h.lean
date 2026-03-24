import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure Mechanism (n : ℕ) (Θ : Type*) (K : Type*) where
  project : Θ → K
  transfer : Θ → Fin n → ℤ

def BudgetBalanced {n : ℕ} {Θ : Type*} {K : Type*} (m : Mechanism n Θ K) : Prop :=
  ∀ θ : Θ, ∑ i : Fin n, m.transfer θ i = 0