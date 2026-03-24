import Mathlib

open Matrix Finset

/-- The index of a regular equilibrium price vector in a general equilibrium economy.
    Given the Jacobian matrix Dẑ(p) of excess demand (with numeraire),
    the index is (-1)^(L-1) * sign(det(Dẑ(p))). -/
noncomputable def equilibriumIndex
    (L : ℕ)
    (Dz : Matrix (Fin (L - 1)) (Fin (L - 1)) ℝ) : ℤ :=
  (-1) ^ (L - 1) * SignType.sign (Dz.det)