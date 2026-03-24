import Mathlib

open SimpleGraph

theorem card_connectedComponents_deleteEdges_le {V : Type} [Fintype V] (G : SimpleGraph V) (e : Sym2 V) :
    Fintype.card (G.deleteEdges {e}).ConnectedComponent ≤ Fintype.card G.ConnectedComponent + 1 := by
  sorry