import Mathlib

open Matrix
open Topology

theorem claim_3Gb {n : ℕ} (D : Matrix (Fin n) (Fin n) ℝ)
    (hSym : D.IsSymm) (ℓ k : Fin n) :
    D ℓ k = D k ℓ := by
  have h := hSym
  rw [Matrix.IsSymm] at h
  have : Dᵀ ℓ k = D ℓ k := by rw [h]
  simp [Matrix.transpose_apply] at this
  exact this.symm