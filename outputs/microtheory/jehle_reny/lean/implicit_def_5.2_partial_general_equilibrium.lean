import Mathlib

def IsPartialEquilibrium {L : ℕ} (z : (Fin L → ℝ) → Fin L → ℝ) (p : Fin L → ℝ) (k : Fin L) : Prop :=
  z p k = 0