import Mathlib

open Finset BigOperators
open BigOperators

noncomputable section

variable {S K : ℕ}

def portfolioCost (q θ : Fin K → ℝ) : ℝ := ∑ k : Fin K, q k * θ k