import Mathlib

-- We model quantity and price as real numbers.
-- A DemandCurve is a function that maps a quantity (ℝ) to a price (ℝ).
def DemandCurve : Type := ℝ → ℝ
-- A SupplyCurve is a function that maps a quantity (ℝ) to a price (ℝ).