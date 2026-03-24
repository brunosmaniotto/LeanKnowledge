import Mathlib

open Complex
open Filter

noncomputable section

def residue (n : ℕ) : ℂ := (-1) ^ n / (Nat.factorial n : ℂ)