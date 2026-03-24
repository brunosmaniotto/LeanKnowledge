import Mathlib

inductive GTree where
  | leaf (v : ℤ)
  | p1 (l r : GTree)
  | p2 (l r : GTree)

def GTree.eval : GTree → ℤ
  | .leaf v => v
  | .p1 l r => max l.eval r.eval
  | .p2 l r => min l.eval r.eval