import Mathlib.Combinatorics.SimpleGraph.DegreeSum

open Finset
open SimpleGraph

variable {V : Type*} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj]

theorem handshake_lemma : ∑ v : V, G.degree v = 2 * (G.edgeFinset.card) :=
  G.sum_degrees_eq_twice_card_edges