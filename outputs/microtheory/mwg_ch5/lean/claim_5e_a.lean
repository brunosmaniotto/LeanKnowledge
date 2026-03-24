import Mathlib

open Matrix
open Topology

variable {n : ℕ}

theorem aggregate_supply_matrix_properties
    (A B : Matrix (Fin n) (Fin n) ℝ)
    (hAs : A.IsSymm) (hBs : B.IsSymm)
    (hApsd : A.PosSemidef) (hBpsd : B.PosSemidef) :
    (A + B).IsSymm ∧ (A + B).PosSemidef :=
  ⟨hAs.add hBs, hApsd.add hBpsd⟩