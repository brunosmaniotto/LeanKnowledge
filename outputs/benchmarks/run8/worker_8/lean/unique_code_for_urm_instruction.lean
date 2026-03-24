import Mathlib

open Nat

inductive URMInstr : Type
  | Z : ℕ → URMInstr
  | S : ℕ → URMInstr
  | C : ℕ → ℕ → URMInstr
  | J : ℕ → ℕ → ℕ → URMInstr

def Valid : URMInstr → Prop
  | URMInstr.Z n => n ≥ 1
  | URMInstr.S n => n ≥ 1
  | URMInstr.C _ n => n ≥ 1
  | URMInstr.J _ n _ => n ≥ 1