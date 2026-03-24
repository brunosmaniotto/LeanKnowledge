import Mathlib
open Topology

/-- The Allais paradox: if a vNM expected utility function exists and L₁ ≻ L'₁,
    then L₂ ≻ L'₂. Hence preferring L₁ over L'₁ and L'₂ over L₂ is inconsistent
    with expected utility theory.

    L₁  = $0.5M with certainty:  EU = u₀₅
    L'₁ = 0.10·u₂₅ + 0.89·u₀₅ + 0.01·u₀
    L₂  = 0.11·u₀₅ + 0.89·u₀
    L'₂ = 0.10·u₂₅ + 0.90·u₀ -/
theorem allais_paradox_inconsistency (u0 u05 u25 : ℝ)
    (h : u05 > 0.10 * u25 + 0.89 * u05 + 0.01 * u0) :
    0.11 * u05 + 0.89 * u0 > 0.10 * u25 + 0.90 * u0 := by
  linarith