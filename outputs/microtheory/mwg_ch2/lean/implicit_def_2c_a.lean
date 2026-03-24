import Mathlib

/-- A consumption set is a subset X ⊆ ℝ^L representing the consumption bundles
    that an individual can conceivably consume given physical constraints. -/
structure ConsumptionSet (L : ℕ) where
  /-- The carrier set: a subset of ℝ^L. -/
  carrier : Set (Fin L → ℝ)
  /-- The consumption set is nonempty (an individual must have some feasible consumption). -/
  nonempty : carrier.Nonempty