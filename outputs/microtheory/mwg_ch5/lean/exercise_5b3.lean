import Mathlib

open Set
open Topology

noncomputable section

variable {n : ℕ}

def ProdSet (f : (Fin n → ℝ) → ℝ) : Set ((Fin n → ℝ) × ℝ) :=
  {p | p.2 ≤ f p.1}