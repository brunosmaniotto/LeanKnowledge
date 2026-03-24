import Mathlib
open Topology

/-- The feasible set B: a subset of the consumption set X consisting of all
    alternative consumption plans that are both conceivable and realistically
    obtainable given the consumer's circumstances. Formally, B ⊂ X. -/
abbrev FeasibleSet {L : ℕ} (X : Set (Fin L → ℝ)) := {B : Set (Fin L → ℝ) // B ⊆ X}