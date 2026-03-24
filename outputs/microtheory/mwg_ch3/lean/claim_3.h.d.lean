import Mathlib

open Matrix Finset

variable (L : ℕ) (hL : L > 2)

-- Price and wealth spaces
variable (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))  -- Marshallian demand x(p, w)
variable (S : (Fin L → ℝ) → ℝ → Matrix (Fin L) (Fin L) ℝ)  -- Slutsky matrix S(p, w)

-- Symmetry of the Slutsky matrix
def slutsky_symmetric (S : (Fin L → ℝ) → ℝ → Matrix (Fin L) (Fin L) ℝ) : Prop :=
  ∀ p w, (S p w).IsSymm

-- Negative semidefiniteness