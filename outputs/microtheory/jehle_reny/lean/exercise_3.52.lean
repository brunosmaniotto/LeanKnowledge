import Mathlib

open Finset BigOperators
open BigOperators

noncomputable section

variable {M N : ℕ}

def dotProd {k : ℕ} (a b : Fin k → ℝ) : ℝ := ∑ i : Fin k, a i * b i