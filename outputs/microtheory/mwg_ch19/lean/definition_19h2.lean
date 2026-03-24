import Mathlib

open Finset BigOperators
open Topology

/-- A rational expectations equilibrium price function.
    For every state s, p(s) clears the spot market when each consumer i
    knows s ∈ E_{p(s),σ_i(s)} and evaluates bundles using updated utilities. -/
structure RationalExpectationsEquilibrium
    (S : Type*) [Fintype S] [DecidableEq S]
    (I : Type*) [Fintype I]
    (p : S → ℝ)
    (σ : I → S → ℝ)
    (π : S → I → ℝ)
    (u : S → I → (Fin 2 → ℝ) → ℝ)
    (ω : I → S → (Fin 2 → ℝ))
    where
  /-- The information set: states indistinguishable from s given price and signal -/
  infoSet : I → S → Finset S
  infoSet_spec : ∀ (i : I) (s s' : S),
    s' ∈ infoSet i s ↔ (p s' = p s ∧ σ i s' = σ i s)
  /-- Updated conditional probability of state s' given consumer i observes p(s) and σ_i(s) -/
  condProb : I → S → S → ℝ
  condProb_nonneg : ∀ (i : I) (s s' : S), 0 ≤ condProb i s s'
  condProb_support : ∀ (i : I) (s s' : S),
    s' ∉ infoSet i s → condProb i s s' = 0
  condProb_sum : ∀ (i : I) (s : S),
    Finset.univ.sum (fun s' => condProb i s s') = 1
  condProb_bayes : ∀ (i : I) (s s' : S),
    s' ∈ infoSet i s →
    condProb i s s' = π s' i / (infoSet i s).sum (fun s'' => π s'' i)
  /-- Each consumer's optimal demand given updated beliefs -/
  demand : I → S → (Fin 2 → ℝ)
  /-- Demand maximizes the conditional expected utility -/
  demand_optimal : ∀ (i : I) (s : S) (x : Fin 2 → ℝ),
    Finset.univ.sum (fun s' => condProb i s s' * u s' i x) ≤
    Finset.univ.sum (fun s' => condProb i s s' * u s' i (demand i s))
  /-- Market clearing: total demand equals total endowment in every state -/
  marketClearing : ∀ (s : S),
    Finset.univ.sum (fun i => demand i s) = Finset.univ.sum (fun i => ω i s)