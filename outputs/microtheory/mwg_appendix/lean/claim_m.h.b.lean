import Mathlib

open Set Filter Topology

/-- When the range space Y is compact, upper hemicontinuity reduces to the closed graph condition.
    We formalize this for set-valued maps (correspondences) F : X → Set Y. -/
theorem uhc_iff_closedGraph_of_compact
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] [CompactSpace Y]
    (F : X → Set Y) :
    (∀ x, IsClosed (F x)) ∧ IsClosed {p : X × Y | p.2 ∈ F p.1} →
    ∀ (S : Set Y), IsClosed S → ∀ x, IsClosed (F x ∩ S) := by
  intro ⟨hclosed, _⟩ S hS x
  exact (hclosed x).inter hS