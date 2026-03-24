import Mathlib

variable {V : Type u} (G : SimpleGraph V)

theorem Graph_is_Bipartite_iff_No_Odd_Cycles :
    G.IsBipartite ↔ ∀ (u : V) (p : G.Walk u u), p.IsCycle → Even p.length := by
  sorry