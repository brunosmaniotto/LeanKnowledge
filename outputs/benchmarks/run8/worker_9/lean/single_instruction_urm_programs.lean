import Mathlib

open Function

inductive Instruction where
  | zero (n : ℕ) : Instruction
  | succ (n : ℕ) : Instruction
  | jump (m n q : ℕ) : Instruction

structure State where
  reg : ℕ → ℕ
  pc : ℕ

def init (x : ℕ) : State :=
  { reg := fun i => if i = 1 then x else 0, pc := 1 }