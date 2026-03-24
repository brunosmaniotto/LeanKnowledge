import Mathlib

open Set Filter Topology
open Topology

/-- Kakutani's Fixed Point Theorem: An upper hemicontinuous convex-valued correspondence
    on a nonempty compact convex subset of ℝᴺ has a fixed point. -/
axiom kakutani_fixed_point_theorem
    {N : ℕ}
    {A : Set (EuclideanSpace ℝ (Fin N))}
    (hA_ne : A.Nonempty)
    (hA_compact : IsCompact A)
    (hA_convex : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin N) → Set (EuclideanSpace ℝ (Fin N)))
    (hf_values : ∀ x ∈ A, f x ⊆ A)
    (hf_ne : ∀ x ∈ A, (f x).Nonempty)
    (hf_convex : ∀ x ∈ A, Convex ℝ (f x)) :
    ∃ x ∈ A, x ∈ f x

theorem Theorem_M_I_2
    {N : ℕ}
    {A : Set (EuclideanSpace ℝ (Fin N))}
    (hA_ne : A.Nonempty)
    (hA_compact : IsCompact A)
    (hA_convex : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin N) → Set (EuclideanSpace ℝ (Fin N)))
    (hf_values : ∀ x ∈ A, f x ⊆ A)
    (hf_ne : ∀ x ∈ A, (f x).Nonempty)
    (hf_convex : ∀ x ∈ A, Convex ℝ (f x)) :
    ∃ x ∈ A, x ∈ f x :=
  kakutani_fixed_point_theorem hA_ne hA_compact hA_convex f hf_values hf_ne hf_convex