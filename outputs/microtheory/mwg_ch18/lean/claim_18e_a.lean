import Mathlib

open BigOperators
open Topology

/-- A social welfare function v is homogeneous of degree one:
    v(r * I₁, ..., r * Iₕ) = r * v(I₁, ..., Iₕ) for all r. -/
theorem Claim_18E_a
    {H : ℕ}
    (v : (Fin H → ℝ) → ℝ)
    (hv : ∀ (r : ℝ) (I : Fin H → ℝ), v (fun h => r * I h) = r * v I)
    (r : ℝ) (I : Fin H → ℝ) :
    v (fun h => r * I h) = r * v I := by
  exact hv r I