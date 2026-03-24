import Mathlib

/-- A consumption bundle (commodity vector) over `L` commodities.
    Entry `x l` is the amount of commodity `l` consumed. -/
abbrev ConsumptionBundle (L : ℕ) := Fin L → ℝ