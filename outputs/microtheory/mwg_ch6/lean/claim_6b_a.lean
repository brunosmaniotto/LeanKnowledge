import Mathlib

open Finset BigOperators
open BigOperators

def Simplex (N : ℕ) : Set (Fin N → ℝ) :=
  {p | (∀ i, 0 ≤ p i) ∧ ∑ i, p i = 1}

noncomputable def degenerateLottery (N : ℕ) [NeZero N] (j : Fin N) : Fin N → ℝ :=
  fun i => if i = j then 1 else 0