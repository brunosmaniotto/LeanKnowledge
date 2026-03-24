import Mathlib
open ArithmeticFunction
open Finset

def totient' : ArithmeticFunction ℤ :=
  ⟨fun n => (Nat.totient n : ℤ), by simp⟩