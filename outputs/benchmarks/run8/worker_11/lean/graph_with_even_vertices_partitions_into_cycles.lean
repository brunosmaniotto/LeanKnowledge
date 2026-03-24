import Mathlib
open SimpleGraph
open Finset
open Set

variable {V : Type} [Fintype V] [DecidableEq V]

/-- Auxiliary lemma: In a cycle, each vertex in its support has exactly two incident edges. -/
lemma cycle_edges_at_vertex (G : SimpleGraph V) {v : V} (c : G.Walk v v) (hc : c.IsCycle)
    (w : V) : (c.edges.toFinset.filter (λ e => w ∈ e)).card = if w ∈ c.support then 2 else 0 := by
  sorry  -- Non-trivial; requires analyzing cycle structure