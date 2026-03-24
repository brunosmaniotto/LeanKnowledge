import Mathlib

structure GameTree where
  Node : Type*
  Player : Type*
  player : Node → Player
  indistinguishable : Player → Node → Node → Prop

structure InfoSet (G : GameTree) (p : G.Player) where
  representative : G.Node
  playerOwns : G.player representative = p

def DistinguishableCircumstance (G : GameTree) (p : G.Player) := InfoSet G p