import Mathlib

open Matrix Finset

variable {L : ℕ}

noncomputable def quadForm (M : Matrix (Fin L) (Fin L) ℝ) (v : Fin L → ℝ) : ℝ :=
  dotProduct v (M.mulVec v)

def IsProportional (u v : Fin L → ℝ) : Prop :=
  ∃ α : ℝ, u = α • v

axiom prop_17F4 {L : ℕ} (p : Fin L → ℝ) (D_p_z : Matrix (Fin L) (Fin L) ℝ)
    (hgs : True) (hclear : True)
    (dp : Fin L → ℝ) (hdp : dp ≠ 0) (hnp : ¬ IsProportional dp p) :
    quadForm D_p_z dp < 0