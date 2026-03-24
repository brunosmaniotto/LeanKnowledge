import Mathlib

namespace URM

inductive Instruction where
  | copy (a b : ℕ) : Instruction

structure State where
  reg : ℕ → ℕ

def step (s : State) (instr : Instruction) : State :=
  match instr with
  | Instruction.copy a b => { reg := fun i => if i = b then s.reg a else s.reg i }