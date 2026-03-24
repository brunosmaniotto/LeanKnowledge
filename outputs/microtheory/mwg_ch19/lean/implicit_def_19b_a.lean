import Mathlib
open Topology

/-- An information structure on a state space `S` is a partition of `S`:
    a collection of nonempty subsets (events) that are pairwise disjoint
    and whose union covers all of `S`. -/
structure InformationStructure (S : Type*) where
  /-- The collection of events forming the partition -/
  events : Set (Set S)
  /-- Every state belongs to some event -/
  covering : ∀ s : S, ∃ E ∈ events, s ∈ E
  /-- Distinct events are disjoint -/
  pairwise_disjoint : ∀ E ∈ events, ∀ E' ∈ events, E ≠ E' → Disjoint E E'