import Mathlib

inductive GTree where
  | leaf : (ℤ × ℤ) → GTree
  | node : (player : Fin 2) → (left : GTree) → (right : GTree) → GTree

def backwardInduction : GTree → (ℤ × ℤ)
  | .leaf p => p
  | .node player l r =>
    let lv := backwardInduction l
    let rv := backwardInduction r
    if player = 0 then (if lv.1 ≥ rv.1 then lv else rv)
    else (if lv.2 ≥ rv.2 then lv else rv)