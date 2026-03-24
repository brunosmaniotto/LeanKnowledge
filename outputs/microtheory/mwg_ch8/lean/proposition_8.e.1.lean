import Mathlib

/-
Proposition 8.E.1: A strategy profile is a Bayesian Nash Equilibrium iff
for every player i and every type θ_i with positive probability,
the interim expected utility condition holds.

We axiomatize the Bayesian game structure and prove the equivalence
by decomposing ex-ante expected utility into a sum of interim utilities.
-/

noncomputable section

open Finset BigOperators
open Topology

-- Bayesian game components
variable {I : Type*} [Fintype I] [DecidableEq I]  -- players
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]  -- strategy sets
variable {Θ : I → Type*} [∀ i, Fintype (Θ i)] [∀ i, DecidableEq (Θ i)]  -- type spaces

-- A strategy profile maps each player's type to a strategy
def StrategyProfile (S : I → Type*) (Θ : I → Type*) := ∀ i, Θ i → S i

-- Probability of type profile θ_{-i} conditional on θ_i
variable (condProb : ∀ i, Θ i → (∀ j : {j // j ≠ i}, Θ j) → ℝ)

-- Marginal probability of θ_i
variable (margProb : ∀ i, Θ i → ℝ)

-- Utility function for player i
variable (u : ∀ i, S i → (∀ j : {j // j ≠ i}, S j) → Θ i → ℝ)

-- Others' strategies applied to their types