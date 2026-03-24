import Mathlib
open Topology

/-- The consumer's problem (MWG equation 1.4): `x_star` solves the consumer's problem
    over feasible set `B` with preference relation `pref` (≿) if `x_star ∈ B` and
    `x_star ≿ x` for all `x ∈ B`. -/
def IsConsumerOptimum {n : ℕ} (pref : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin n) → Prop)
    (B : Set (EuclideanSpace ℝ (Fin n))) (x_star : EuclideanSpace ℝ (Fin n)) : Prop :=
  x_star ∈ B ∧ ∀ x ∈ B, pref x_star x