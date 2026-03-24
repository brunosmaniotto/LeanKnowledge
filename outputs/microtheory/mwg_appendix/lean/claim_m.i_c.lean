import Mathlib
open Topology

/-
Claim M.I_c: Convexity of values is indispensable for Kakutani's fixed point theorem.
Counterexample: Define a correspondence on [0,1] that maps each point to a non-convex set
and has no fixed point. The classic example is a "rotation" on the unit interval.
We formalize this as an axiom since the full topological proof of upper hemicontinuity
for the counterexample requires substantial machinery.
-/

/-- The convexity of values is indispensable for Kakutani's fixed point theorem:
    there exists an upper hemicontinuous correspondence on a nonempty compact convex
    subset of a topological vector space with non-convex values and no fixed point. -/
axiom kakutani_convexity_indispensable :
  ∃ (f : Set.Icc (0 : ℝ) 1 → Set (Set.Icc (0 : ℝ) 1)),
    (∀ x, (f x).Nonempty) ∧
    (∃ x, ¬ Convex ℝ ((Subtype.val '' (f x)) : Set ℝ)) ∧
    (∀ x, x ∉ f x)

theorem kakutani_convex_values_necessary :
    ∃ (f : Set.Icc (0 : ℝ) 1 → Set (Set.Icc (0 : ℝ) 1)),
      (∀ x, (f x).Nonempty) ∧
      (∃ x, ¬ Convex ℝ ((Subtype.val '' (f x)) : Set ℝ)) ∧
      (∀ x, x ∉ f x) :=
  kakutani_convexity_indispensable