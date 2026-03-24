import Mathlib

/-- A commodity vector (or commodity bundle) for an economy with `L` commodities.
    Each bundle is a point in ℝ^L, listing the amount of each commodity. -/
abbrev CommodityBundle (L : ℕ) := Fin L → ℝ