import Mathlib
open Topology

/-- The production possibility set Yʲ ⊆ ℝⁿ for a firm.
    Summarises all technologically feasible production plans,
    where each vector y ∈ Yʲ specifies net outputs (positive)
    and net inputs (negative) for each of the n commodities. -/
abbrev ProductionPossibilitySet (n : ℕ) := Set (Fin n → ℝ)