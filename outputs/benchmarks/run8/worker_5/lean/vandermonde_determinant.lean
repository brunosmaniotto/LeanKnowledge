import Mathlib

open Matrix
open Finset

variable {R : Type} [CommRing R] [IsDomain R] {n : ℕ} (x : Fin n → R)

theorem Vandermonde_Determinant : det (vandermonde x) = ∏ i : Fin n, ∏ j ∈ Ioi i, (x j - x i) :=
  det_vandermonde x