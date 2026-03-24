import Mathlib
open Topology

structure ExtensiveFormGame where
  Player : Type*
  Node : Type*
  Action : Type*
  playerAt : Node → Player
  actionsAt : Node → Set Action

structure ExtensiveFormGame.BehaviorStrategy (G : ExtensiveFormGame) (i : G.Player) where
  prob : G.Node → G.Action → ℝ

structure ExtensiveFormGame.BeliefSystem (G : ExtensiveFormGame) where
  μ : G.Node → ℝ

def ExtensiveFormGame.IsSequentiallyRationalAt
    (G : ExtensiveFormGame) [DecidableEq G.Player]
    (condExpPayoff : G.Node → G.BeliefSystem → ((i : G.Player) → G.BehaviorStrategy i) → ℝ)
    (σ : (i : G.Player) → G.BehaviorStrategy i)
    (μ : G.BeliefSystem) (h : G.Node) : Prop :=
  ∀ σ' : G.BehaviorStrategy (G.playerAt h),
    condExpPayoff h μ σ ≥ condExpPayoff h μ (Function.update σ (G.playerAt h) σ')