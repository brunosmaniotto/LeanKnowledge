import Mathlib
open Finset
open scoped BigOperators

noncomputable section

variable {N : ℕ} (hN : 0 < N)
variable (T : Fin N → Type)
variable (c_bar_interim : (i : Fin N) → T i → ℝ)
variable (c_bar_exante : Fin N → ℝ)

def σ : Equiv.Perm (Fin N) :=
  Fin.cycleRange ⟨0, hN⟩