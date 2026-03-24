import Mathlib.Data.List.Basic
import Mathlib.Data.Nat.Basic
import Mathlib.Data.Part

namespace URM

inductive Instruction : Type
  | Z : ℕ → Instruction
  | S : ℕ → Instruction
  | J : ℕ → ℕ → ℕ → Instruction

abbrev Program : Type := List Instruction

def registersUsed : Instruction → ℕ
  | Instruction.Z i => i
  | Instruction.S i => i
  | Instruction.J m n _ => max m n