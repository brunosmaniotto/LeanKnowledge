import Mathlib
open scoped symmDiff
open Topology

/-- The marginal contribution of an individual of type `h` in a finite economy.
    Given a valuation function `v` on population vectors and a population vector `I`,
    Δ_h v(I) = v(I) - v(I with I_h decremented by 1). -/
def marginalContribution (H : ℕ) (v : (Fin H → ℕ) → ℤ) (I : Fin H → ℕ) (h : Fin H) : ℤ :=
  v I - v (Function.update I h (I h - 1))