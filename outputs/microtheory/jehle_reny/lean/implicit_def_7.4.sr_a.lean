import Mathlib

open BigOperators
open Topology

/-- Finite extensive form game with tree structure. -/
structure FinExtGame where
  Node : Type*
  Action : Type*
  Player : Type*
  actions : Node → Finset Action
  next : Node → Action → Node
  isTerminal : Node → Bool
  terminalPayoff : Node → Player → ℝ
  playerAt : Node → Player

/-- Behavioral strategy: probability of choosing each action at each node. -/
def BehavioralStrategy (G : FinExtGame) := G.Node → G.Action → ℝ

/-- The conditional payoff u_i(b | x): player i's expected payoff starting from
    node x under behavioral strategy b, treating x as the root of a subgame.
    Defined recursively with a depth bound (the game tree is finite). -/
noncomputable def conditionalPayoff (G : FinExtGame) (b : BehavioralStrategy G)
    (i : G.Player) : ℕ → G.Node → ℝ
  | 0, x => G.terminalPayoff x i
  | n + 1, x => if G.isTerminal x then G.terminalPayoff x i
    else (G.actions x).sum fun a => b x a * conditionalPayoff G b i n (G.next x a)