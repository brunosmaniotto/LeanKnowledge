import Mathlib

open Matrix Finset BigOperators
open BigOperators

variable {N M : ℕ}

noncomputable def hessianLagrangian
    (D2f : Matrix (Fin N) (Fin N) ℝ)
    (D2g : Fin M → Matrix (Fin N) (Fin N) ℝ)
    (lam : Fin M → ℝ) : Matrix (Fin N) (Fin N) ℝ :=
  D2f - ∑ m, lam m • D2g m

def constraintSubspace (Dg : Fin M → Fin N → ℝ) : Set (Fin N → ℝ) :=
  {z | ∀ m, ∑ i, Dg m i * z i = 0}