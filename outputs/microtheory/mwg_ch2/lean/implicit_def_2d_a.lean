import Mathlib

/-- A price vector for `L` commodities: a function `Fin L → ℝ` with all components strictly positive. -/
abbrev PriceVector (L : ℕ) := { p : Fin L → ℝ // ∀ l, 0 < p l }