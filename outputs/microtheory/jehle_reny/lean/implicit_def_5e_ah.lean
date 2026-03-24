import Mathlib

variable {I : Type*} [Fintype I] {L : ℕ}

def Envies (pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (x : I → Fin L → ℝ) (i j : I) : Prop :=
  pref i (x j) (x i) ∧ ¬pref i (x i) (x j)