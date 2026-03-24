import Mathlib

inductive GameTree where
  | p1win : GameTree
  | p2win : GameTree
  | draw  : GameTree
  | p1move (l r : GameTree) : GameTree
  | p2move (l r : GameTree) : GameTree

def GameTree.p1Wins : GameTree → Prop
  | .p1win => True
  | .p2win | .draw => False
  | .p1move l r => l.p1Wins ∨ r.p1Wins
  | .p2move l r => l.p1Wins ∧ r.p1Wins