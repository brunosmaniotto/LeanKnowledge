import Mathlib
open Set
open Finset

noncomputable section

def X_set : Set (ℝ × ℝ) := {p | p.1 + p.2 = 1 ∧ 0 ≤ p.1 ∧ 0 ≤ p.2}