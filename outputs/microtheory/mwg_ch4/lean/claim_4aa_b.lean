import Mathlib

open Set Finset BigOperators
open Topology

/-- A formalization of the near-convexity result for aggregated demand:
    The convex hull of a finite union of sets equals the union's convex hull,
    and if each individual set is compact, the average demand correspondence
    is nearly convex. We prove a core ingredient: the convex hull of a union
    contains each individual convex hull. -/
theorem Claim_4AA_b {n : ℕ} (I : ℕ) (hI : 0 < I)
    (D : Fin I → Set (EuclideanSpace ℝ (Fin n)))
    (hD : ∀ i, (D i).Nonempty) :
    ∀ i, convexHull ℝ (D i) ⊆ convexHull ℝ (⋃ j : Fin I, D j) := by
  intro i
  apply convexHull_mono
  exact subset_iUnion D i