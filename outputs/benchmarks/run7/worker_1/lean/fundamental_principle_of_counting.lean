import Mathlib

open Finset

theorem fundamental_principle_of_counting {α : Type*} [DecidableEq α] (A : Finset α) (P : Finset (Finset α))
    (hdisj : ∀ B1 ∈ P, ∀ B2 ∈ P, B1 ≠ B2 → Disjoint B1 B2) (hcover : (A : Set α) = ⋃ B ∈ P, (B : Set α)) :
    A.card = ∑ B ∈ P, B.card := by
  have h : A = P.biUnion id := by
    apply Finset.coe_inj.mp
    rw [Finset.coe_biUnion]
    exact hcover
  rw [h]
  exact Finset.card_biUnion hdisj