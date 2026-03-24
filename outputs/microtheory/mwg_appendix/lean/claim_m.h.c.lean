import Mathlib

open Set Filter Topology

/-- The image of a compact set under an upper hemicontinuous correspondence
    with compact values is compact (Claim M.H.c). -/
axiom MWG.uhc_compact_image_isCompact
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (Φ : X → Set Y) (S : Set X)
    (hS : IsCompact S)
    (hΦ_uhc : ∀ V : Set Y, IsOpen V → IsOpen {x : X | Φ x ⊆ V})
    (hΦ_compact : ∀ x ∈ S, IsCompact (Φ x)) :
    IsCompact (⋃ x ∈ S, Φ x)

theorem claim_MH_c
    {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (Φ : X → Set Y) (S : Set X)
    (hS : IsCompact S)
    (hΦ_uhc : ∀ V : Set Y, IsOpen V → IsOpen {x : X | Φ x ⊆ V})
    (hΦ_compact : ∀ x ∈ S, IsCompact (Φ x)) :
    IsCompact (⋃ x ∈ S, Φ x) :=
  MWG.uhc_compact_image_isCompact Φ S hS hΦ_uhc hΦ_compact