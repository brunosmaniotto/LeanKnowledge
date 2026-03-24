import Mathlib

namespace URM

inductive Instruction
  | C (a b : ℕ) : Instruction
  | J (a b t : ℕ) : Instruction

def Program : Type := List Instruction