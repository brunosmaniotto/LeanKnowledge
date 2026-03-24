import Mathlib

namespace URM

inductive Instruction : Type
  | zero : Nat → Instruction
  | succ : Nat → Instruction
  | copy : Nat → Nat → Instruction
  | jump : Nat → Nat → Nat → Instruction

-- URM program = list of instructions
abbrev Program := List Instruction

-- Encoding function (simplified for illustration)
def encodeInstruction : Instruction → Nat
  | .zero r => 4 * r
  | .succ r => 4 * r + 1
  | .copy r s => 4 * (2^r * 3^s) + 2
  | .jump r s t => 4 * (2^r * 3^s * 5^t) + 3