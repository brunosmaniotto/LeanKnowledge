import Mathlib

/-- A production set is a subset of ℝ^L representing all feasible production plans
for a firm. It is taken as a primitive datum of the theory. -/
abbrev ProductionSet (L : ℕ) := Set (Fin L → ℝ)