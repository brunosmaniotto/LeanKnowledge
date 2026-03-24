import Mathlib

open Finset

theorem prod_partition {ι κ M : Type*} [CommMonoid M] [DecidableEq ι] [DecidableEq κ]
    (A : Finset ι) (x : ι → M) (K : Finset κ) (B : κ → Finset ι)
    (h_disj : ∀ i ∈ K, ∀ j ∈ K, i ≠ j → Disjoint (B i) (B j))
    (h_cover : K.biUnion B = A) :
    ∏ a ∈ A, x a = ∏ k ∈ K, ∏ a ∈ B k, x a := by
  rw [← h_cover, prod_biUnion h_disj]