import Mathlib

open Ideal

def ψ : ℕ → Ideal ℤ := fun n => Ideal.span {(n : ℤ)}