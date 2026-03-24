import Mathlib
open Topology

structure SignalingGame where
  Θ : Type*
  Action : Type*
  Response : Type*
  u₁ : Action → Response → Θ → ℝ
  S_star : Set Θ → Action → Set Response

def StrictlyDominatedStronger (G : SignalingGame) (a : G.Action) (θ : G.Θ) : Prop :=
  ∃ a' : G.Action,
    (∃ lb : ℝ, (∀ s' ∈ G.S_star Set.univ a', lb ≤ G.u₁ a' s' θ) ∧
      ∃ ub : ℝ, (∀ s ∈ G.S_star Set.univ a, G.u₁ a s θ ≤ ub) ∧ lb > ub)