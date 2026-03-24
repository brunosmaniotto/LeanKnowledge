import Mathlib

open Set Filter Topology
open Topology

theorem argmin_multivalued_of_two_minimizers
    {n : ℕ} (p x y : EuclideanSpace ℝ (Fin n))
    (S : Set (EuclideanSpace ℝ (Fin n)))
    (hx : x ∈ S) (hy : y ∈ S)
    (hxy : x ≠ y)
    (hxmin : ∀ z ∈ S, @inner ℝ _ _ p x ≤ @inner ℝ _ _ p z)
    (hymin : ∀ z ∈ S, @inner ℝ _ _ p y ≤ @inner ℝ _ _ p z)
    : @inner ℝ _ _ p x = @inner ℝ _ _ p y := by
  have h1 := hxmin y hy
  have h2 := hymin x hx
  linarith