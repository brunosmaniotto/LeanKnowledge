import Mathlib

/-- The production possibility set Y ⊆ ℝᵐ. Each vector y ∈ Y is a production plan:
    yᵢ < 0 means resource i is an input; yᵢ > 0 means resource i is an output. -/
abbrev ProductionPossibilitySet (m : ℕ) := Set (Fin m → ℝ)