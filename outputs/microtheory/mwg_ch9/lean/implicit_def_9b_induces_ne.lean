import Mathlib

structure ExtensiveFormGame where
  Node : Type
  numPlayers : ℕ
  isTerminal : Node → Prop
  toMove : Node → Fin numPlayers
  actions : Node → Finset ℕ
  successor : Node → ℕ → Option Node
  utility : Fin numPlayers → Node → ℝ

def StrategyProfile (G : ExtensiveFormGame) := G.Node → ℕ

structure Subgame (G : ExtensiveFormGame) where
  root : G.Node
  nodes : Set G.Node
  root_mem : root ∈ nodes