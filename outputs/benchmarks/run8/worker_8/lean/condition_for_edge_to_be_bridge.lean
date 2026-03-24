import Mathlib

open SimpleGraph

variable {V : Type} [DecidableEq V] (G : SimpleGraph V) (hG : G.Connected) (e : Sym2 V) (he : e ∈ G.edgeSet)

theorem condition_for_edge_to_be_bridge :
    G.IsBridge e ↔ ¬∃ (u : V) (p : G.Walk u u), p.IsCycle ∧ e ∈ p.edges := by
  sorry