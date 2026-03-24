import Mathlib
open Topology

/-- The consumption set X: the set of all alternatives, or complete consumption plans,
    that the consumer can conceive. Also called the choice set.
    Parameterized by the number of commodities n. -/
abbrev E.consumptionSet (n : ℕ) := Set (Fin n → ℝ)