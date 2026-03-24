import Mathlib

open Finset BigOperators
open Set
open BigOperators

noncomputable section

variable {N : ℕ} [NeZero N]

def W_utilitarian (y : Fin N → ℝ) : ℝ := ∑ i, y i