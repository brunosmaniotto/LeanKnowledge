import Mathlib

open SimpleGraph

theorem complement_completeBipartiteGraph_eq (V W : Type*) :
    (completeBipartiteGraph V W)ᶜ = (completeGraph V).sum (completeGraph W) := by
  ext x y
  cases x <;> cases y <;>
  simp [completeBipartiteGraph_adj, SimpleGraph.sum, top_adj, 
        Sum.inl_injective.eq_iff, Sum.inr_injective.eq_iff]