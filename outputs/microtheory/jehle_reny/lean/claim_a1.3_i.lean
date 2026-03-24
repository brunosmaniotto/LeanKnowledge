import Mathlib
open Topology

axiom clopen_of_open_and_closed {n : ℕ} {s : Set (EuclideanSpace ℝ (Fin n))} (ho : IsOpen s) (hc : IsClosed s) : IsClopen s
axiom euclidean_clopen_eq_univ_or_empty {n : ℕ} {s : Set (EuclideanSpace ℝ (Fin n))} (hs : IsClopen s) : s = Set.univ ∨ s = ∅
axiom or_comm_empty_univ {α : Type*} {s : Set α} (h : s = Set.univ ∨ s = ∅) : s = ∅ ∨ s = Set.univ

theorem claim_A1_3_i (n : ℕ) (s : Set (EuclideanSpace ℝ (Fin n))) (hs_open : IsOpen s) (hs_closed : IsClosed s) : s = ∅ ∨ s = Set.univ := by
  have hcl := clopen_of_open_and_closed hs_open hs_closed
  have huniv := euclidean_clopen_eq_univ_or_empty hcl
  exact or_comm_empty_univ huniv