import Mathlib

open Finset
open SimpleGraph

variable {V : Type*} [Fintype V] [DecidableEq V] (G : SimpleGraph V) [DecidableRel G.Adj]

/-- The number of vertices of odd degree in a finite simple graph is even. -/
theorem even_card_odd_degree_vertices : Even ((univ : Finset V).filter (fun v => Odd (G.degree v))).card :=
  G.even_card_odd_degree_vertices