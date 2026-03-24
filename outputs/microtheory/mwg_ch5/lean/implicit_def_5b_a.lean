import Mathlib

/-- A production vector (netput vector / production plan) in an economy with `L` commodities.
Each component `y i` represents the net output of commodity `i`:
positive values are outputs, negative values are inputs. -/
abbrev ProductionVector (L : ℕ) := Fin L → ℝ