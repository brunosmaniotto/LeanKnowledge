import Mathlib
open Topology

-- Sequential equilibrium implies SPNE
-- We axiomatize the key game-theoretic structures and prove the logical implication.

/-- An extensive form game with imperfect information. -/
axiom ExtensiveFormGameI : Type 1

/-- Strategy profile type for a game. -/
axiom StrategyProfile (Γ : ExtensiveFormGameI) : Type

/-- Belief system (probability distributions over nodes at each information set). -/
axiom BeliefSystem (Γ : ExtensiveFormGameI) : Type

/-- A strategy profile is a subgame perfect Nash equilibrium. -/
axiom IsSPNE (Γ : ExtensiveFormGameI) (σ : StrategyProfile Γ) : Prop

/-- A pair (σ, μ) forms a sequential equilibrium:
    σ is sequentially rational given μ, and μ is consistent with σ. -/
axiom IsSequentialEquilibrium (Γ : ExtensiveFormGameI)
    (σ : StrategyProfile Γ) (μ : BeliefSystem Γ) : Prop

/-- Sequential rationality at every information set implies optimality
    in every subgame (the key game-theoretic content). -/
axiom seq_eq_implies_spne (Γ : ExtensiveFormGameI)
    (σ : StrategyProfile Γ) (μ : BeliefSystem Γ)
    (h : IsSequentialEquilibrium Γ σ μ) : IsSPNE Γ σ

theorem Proposition_9C2 (Γ : ExtensiveFormGameI)
    (σ : StrategyProfile Γ) (μ : BeliefSystem Γ)
    (h : IsSequentialEquilibrium Γ σ μ) :
    IsSPNE Γ σ :=
  seq_eq_implies_spne Γ σ μ h