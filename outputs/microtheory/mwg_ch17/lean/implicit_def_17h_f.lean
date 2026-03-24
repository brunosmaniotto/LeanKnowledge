import Mathlib

open Set

/-- The quantity tâtonnement model setup: a single production set Y, a fixed production
    vector y ∈ Y, and a short-run equilibrium price function p that maps each production
    vector in Y to an equilibrium price system. -/
structure QuantityTatonnementModel (L : ℕ) where
  /-- The single production set Y ⊆ ℝ^L -/
  Y : Set (Fin L → ℝ)
  /-- The current fixed production vector -/
  y : Fin L → ℝ
  /-- The current production vector belongs to Y -/
  hy : y ∈ Y
  /-- The short-run equilibrium price function: given any production vector in Y,
      returns the equilibrium price system p(y) (as if the short-run production set
      were {y} − ℝ₊^L) -/
  p : Y → (Fin L → ℝ)