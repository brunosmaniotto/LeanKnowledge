import Mathlib
open Topology

variable {n : ℕ}

def SlutskyNegDef (S : (Fin n → ℝ) → ℝ → Matrix (Fin n) (Fin n) ℝ) (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ)) : Prop :=
  ∀ (p : Fin n → ℝ) (w : ℝ) (dp : Fin n → ℝ),
    dp ≠ 0 → (¬∃ t : ℝ, dp = t • p) →
    dotProduct dp ((S p w).mulVec dp) < 0