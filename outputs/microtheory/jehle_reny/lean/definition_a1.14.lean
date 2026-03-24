import Mathlib
open Topology

/-- A sequence in ℝⁿ is bounded if there exists M such that ‖xᵏ‖ ≤ M for all k. (JR Definition A1.14) -/
def M.isBounded {n : ℕ} (x : ℕ → EuclideanSpace ℝ (Fin n)) : Prop :=
  ∃ M : ℝ, ∀ k : ℕ, ‖x k‖ ≤ M