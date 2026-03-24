import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

/-- A perturbation for a finite game assigns to each player and each pure strategy
    a minimum probability ε_i(s_i) ∈ (0,1) such that Σ_{s_i} ε_i(s_i) < 1. -/
structure Perturbation (I : Type*) (S : I → Type*) [Fintype I] [∀ i, Fintype (S i)] where
  ε : ∀ i, S i → ℝ
  ε_pos : ∀ i (s : S i), 0 < ε i s
  ε_lt_one : ∀ i (s : S i), ε i s < 1
  ε_sum_lt_one : ∀ i, ∑ s : S i, ε i s < 1

/-- The perturbed strategy set Δ_ε(S_i): mixed strategies where each pure strategy
    receives at least its minimum probability ε_i(s_i) and probabilities sum to 1. -/
def PerturbedStrategySet {I : Type*} {S : I → Type*} [Fintype I] [∀ i, Fintype (S i)]
    (p : Perturbation I S) (i : I) : Set (S i → ℝ) :=
  { σ | (∀ s, p.ε i s ≤ σ s) ∧ ∑ s : S i, σ s = 1 }

/-- A perturbed game: a normal-form game with perturbed strategy sets replacing
    the standard mixed-strategy simplices. Utility functions are unchanged. -/
structure PerturbedGame (I : Type*) (S : I → Type*) [Fintype I] [∀ i, Fintype (S i)]
    [DecidableEq I] [∀ i, DecidableEq (S i)] where
  u : I → (∀ i, S i → ℝ) → ℝ
  perturbation : Perturbation I S