import Mathlib

def IsRegularEquilibrium
    {L : ℕ} [NeZero L]
    (Dz : (Fin (L - 1) → ℝ) → Matrix (Fin (L - 1)) (Fin (L - 1)) ℝ)
    (p : Fin (L - 1) → ℝ) : Prop :=
  (Dz p).det ≠ 0