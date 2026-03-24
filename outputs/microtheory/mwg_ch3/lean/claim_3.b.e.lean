import Mathlib

open Metric Set Topology
open Topology

variable {n : ℕ}

def LocallyNonsatiated (U : EuclideanSpace ℝ (Fin n) → ℝ) : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin n), ∀ ε > 0,
    ∃ y : EuclideanSpace ℝ (Fin n), dist y x < ε ∧ U x < U y