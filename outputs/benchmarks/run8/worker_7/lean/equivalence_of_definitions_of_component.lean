import Mathlib
open Set

variable {α : Type _} [TopologicalSpace α]

theorem connectedComponent_eq_sUnion (x : α) :
    connectedComponent x = ⋃₀ {s : Set α | IsConnected s ∧ x ∈ s} := by
  ext y
  constructor
  · intro hy
    have h_conn : IsConnected (connectedComponent x) := isConnected_connectedComponent
    have hx : x ∈ connectedComponent x := mem_connectedComponent
    exact ⟨connectedComponent x, ⟨h_conn, hx⟩, hy⟩
  · intro hy
    rcases hy with ⟨s, ⟨hs_conn, hx⟩, hy⟩
    exact hs_conn.subset_connectedComponent hx hy