import Mathlib

open SimpleGraph

structure SignedGraph (V : Type u) where
  graph : SimpleGraph V
  sign : graph.edgeSet → Bool

namespace SignedGraph

def IsBalanced (S : SignedGraph V) : Prop :=
  ∃ (c : V → Bool), ∀ (u v : V) (h : S.graph.Adj u v),
    S.sign ⟨Sym2.mk u v, by rw [mem_edgeSet]; exact h⟩ = (c u != c v)