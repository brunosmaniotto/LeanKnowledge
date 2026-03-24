import Mathlib

open Finset BigOperators
open BigOperators

/-- A correlated equilibrium for a finite normal-form game.
    `I` is the player set, `S i` is the action set for player `i`,
    `T i` is the signal (type) set for player `i`. -/
structure CorrelatedEquilibrium
    (I : Type*) [Fintype I] [DecidableEq I]
    (S : I → Type*) [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]
    (u : (i : I) → ((j : I) → S j) → ℝ) where
  /-- Signal space for each player -/
  T : I → Type*
  [finT : ∀ i, Fintype (T i)]
  [decT : ∀ i, DecidableEq (T i)]
  /-- Joint probability distribution over signal profiles -/
  μ : ((i : I) → T i) → ℝ
  /-- μ is a probability distribution: nonneg -/
  μ_nonneg : ∀ t, 0 ≤ μ t
  /-- μ sums to 1 -/
  μ_sum_one : ∑ t : ((i : I) → T i), μ t = 1
  /-- Decision rule: each player maps their signal to an action -/
  σ : (i : I) → T i → S i
  /-- Obedience / incentive compatibility: no player gains by deviating.
      For each player i and each alternative decision rule σ_i',
      the expected utility under σ is at least as high. -/
  obedience : ∀ (i : I) (σ_i' : T i → S i),
    ∑ t : ((i : I) → T i),
      μ t * u i (Function.update (fun j => σ j (t j)) i (σ i (t i))) ≥
    ∑ t : ((i : I) → T i),
      μ t * u i (Function.update (fun j => σ j (t j)) i (σ_i' (t i)))