import Mathlib

/-- Configuration for an intertemporal production model.
Time is discrete (ℕ), with `L` nondurable commodities per period.
Durability is captured by a storage technology that maps commodity vectors
from one period to the next. -/
structure IntertemporalProductionModel where
  /-- Number of commodities available in each period. -/
  L : ℕ
  /-- L is positive (there is at least one commodity). -/
  hL : L > 0
  /-- Storage technology: maps a commodity bundle at time t to what survives to t+1. -/
  storage : (Fin L → ℝ) → (Fin L → ℝ)