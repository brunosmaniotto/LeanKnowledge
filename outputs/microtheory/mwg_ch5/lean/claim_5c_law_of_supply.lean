import Mathlib

open Matrix Finset BigOperators
open Topology

/-- The law of supply: if the net supply substitution matrix Dy(p) is positive semidefinite,
    then each diagonal entry is nonneg, i.e. ∂yᵢ/∂pᵢ ≥ 0. -/
theorem law_of_supply {n : ℕ} {Dy : Matrix (Fin n) (Fin n) ℝ}
    (hPSD : Dy.PosSemidef) (i : Fin n) :
    0 ≤ Dy i i := by
  have h := hPSD.2 (Finsupp.single i 1)
  simp [Finsupp.sum_single_index] at h
  exact h