import Mathlib

open SimpleGraph

theorem vertex_degree_preserved_by_isomorphism {V W : Type*} [Fintype V] [Fintype W]
    (G : SimpleGraph V) (H : SimpleGraph W) [DecidableRel G.Adj] [DecidableRel H.Adj]
    (φ : G ≃g H) (v : V) : G.degree v = H.degree (φ v) :=
  (φ.degree_eq v).symm