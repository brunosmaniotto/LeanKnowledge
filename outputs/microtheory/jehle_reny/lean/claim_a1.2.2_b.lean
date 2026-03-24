import Mathlib
open Convex
open Topology

theorem Claim_A1_2_2_b {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) :
    Convex ℝ S ↔ ∀ x ∈ S, ∀ y ∈ S, segment ℝ x y ⊆ S :=
  convex_iff_segment_subset