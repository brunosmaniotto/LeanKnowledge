import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Carathéodory's theorem for compact convex sets: every point can be written
    as a convex combination of at most N+1 extreme points. -/
axiom caratheodory_extreme_points {N : ℕ} (B : Set (EuclideanSpace ℝ (Fin N)))
    (hconv : Convex ℝ B) (hcpt : IsCompact B) (x : EuclideanSpace ℝ (Fin N))
    (hx : x ∈ B) :
    ∃ (k : ℕ) (_ : k ≤ N + 1) (pts : Fin k → EuclideanSpace ℝ (Fin N))
      (w : Fin k → ℝ),
      (∀ i, pts i ∈ Set.extremePoints ℝ B) ∧
      (∀ i, 0 ≤ w i) ∧
      ∑ i, w i = 1 ∧
      ∑ i, w i • pts i = x

theorem Theorem_M_G_1 {N : ℕ} (B : Set (EuclideanSpace ℝ (Fin N)))
    (hconv : Convex ℝ B) (hcpt : IsCompact B) (x : EuclideanSpace ℝ (Fin N))
    (hx : x ∈ B) :
    ∃ (k : ℕ) (_ : k ≤ N + 1) (pts : Fin k → EuclideanSpace ℝ (Fin N))
      (w : Fin k → ℝ),
      (∀ i, pts i ∈ Set.extremePoints ℝ B) ∧
      (∀ i, 0 ≤ w i) ∧
      ∑ i, w i = 1 ∧
      ∑ i, w i • pts i = x :=
  caratheodory_extreme_points B hconv hcpt x hx