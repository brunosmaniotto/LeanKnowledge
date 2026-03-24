import Mathlib

namespace URM

-- State: a function from register indices (ℕ) to natural numbers (ℕ)
structure State where
  reg : ℕ → ℕ

-- Initial state for input n: register 1 is n, all others 0.
def init (n : ℕ) : State :=
  { reg := fun i => if i = 1 then n else 0 }

-- Instructions: not needed for the null program, but we define a placeholder.
inductive Instruction : Type

-- A program is a list of instructions.
abbrev Program := List Instruction

-- Step function: for the empty program, there is no next state (halt).