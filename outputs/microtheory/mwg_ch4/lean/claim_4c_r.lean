import Mathlib

open Matrix
open Topology

theorem claim_4C_r :
    ∃ M : Matrix (Fin 2) (Fin 2) ℝ,
      M ≠ Mᵀ := by
  refine ⟨!![0, 1; 0, 0], ?_⟩
  intro h
  have : (!![0, 1; 0, 0] : Matrix (Fin 2) (Fin 2) ℝ) 1 0 = 1 := by
    rw [h]
    simp [transpose_apply, of_apply, cons_val', cons_val_zero, cons_val_one]
  norm_num [of_apply, cons_val', cons_val_zero, cons_val_one] at this