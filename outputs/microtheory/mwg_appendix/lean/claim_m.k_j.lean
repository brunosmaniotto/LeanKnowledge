import Mathlib

open Set
open Topology

/-- Under the conditions of Theorem M.K.3 (convex optimization with convex constraints),
    a sufficient constraint qualification is that the constraint set C has a nonempty interior.
    If C is convex and has nonempty interior, then there exists an interior point in C,
    which serves as a Slater point for constraint qualification. -/
theorem claim_M_K_j
    {n : ℕ} (C : Set (Fin n → ℝ))
    (hC_convex : Convex ℝ C)
    (hC_interior : (interior C).Nonempty) :
    ∃ x ∈ interior C, x ∈ C := by
  obtain ⟨x, hx⟩ := hC_interior
  exact ⟨x, hx, interior_subset hx⟩