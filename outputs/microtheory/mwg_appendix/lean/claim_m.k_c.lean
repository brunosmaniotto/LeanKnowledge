import Mathlib

open Set Filter Topology
open Topology

/-- A local constrained minimizer of f is a local constrained maximizer of -f. -/
theorem local_constrained_min_iff_max_neg
    {n : ℕ} (f : EuclideanSpace ℝ (Fin n) → ℝ) (S : Set (EuclideanSpace ℝ (Fin n)))
    (x : EuclideanSpace ℝ (Fin n)) (hx : x ∈ S) :
    (∃ ε > 0, ∀ y ∈ S, dist y x < ε → f x ≤ f y) ↔
    (∃ ε > 0, ∀ y ∈ S, dist y x < ε → (-f) y ≤ (-f) x) := by
  constructor
  · rintro ⟨ε, hε, hmin⟩
    exact ⟨ε, hε, fun y hy hd => neg_le_neg (hmin y hy hd)⟩
  · rintro ⟨ε, hε, hmax⟩
    exact ⟨ε, hε, fun y hy hd => le_of_neg_le_neg (hmax y hy hd)⟩