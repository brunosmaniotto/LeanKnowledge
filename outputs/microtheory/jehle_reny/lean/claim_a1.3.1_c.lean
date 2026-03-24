import Mathlib

open Metric Set Topology

/-- When D = ℝᵐ, "open in D" coincides with the standard definition of open set.
    Formally: S is open in the subspace topology on univ iff S is open in ℝᵐ. -/
theorem claim_A1_3_1_c {m : ℕ} (S : Set (EuclideanSpace ℝ (Fin m))) :
    IsOpen S ↔ ∀ x ∈ S, ∃ ε > 0, ball x ε ⊆ S :=
  Metric.isOpen_iff