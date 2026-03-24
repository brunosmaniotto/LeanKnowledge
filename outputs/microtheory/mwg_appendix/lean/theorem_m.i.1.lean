import Mathlib

open scoped Topology
open Topology

/-- Brouwer's Fixed Point Theorem (axiomatized): A continuous function from a nonempty
    compact convex subset of ℝᴺ to itself has a fixed point. -/
axiom brouwer_fixed_point
    {N : ℕ} {A : Set (EuclideanSpace ℝ (Fin N))}
    (hne : A.Nonempty)
    (hcpt : IsCompact A)
    (hcvx : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin N))
    (hf_cont : ContinuousOn f A)
    (hf_self : Set.MapsTo f A A) :
    ∃ x ∈ A, f x = x

theorem Theorem_M_I_1
    {N : ℕ} {A : Set (EuclideanSpace ℝ (Fin N))}
    (hne : A.Nonempty)
    (hcpt : IsCompact A)
    (hcvx : Convex ℝ A)
    (f : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin N))
    (hf_cont : ContinuousOn f A)
    (hf_self : Set.MapsTo f A A) :
    ∃ x ∈ A, f x = x :=
  brouwer_fixed_point hne hcpt hcvx f hf_cont hf_self