import Mathlib

-- Define URM instructions (simplified for the purpose of this proof)
inductive URMInstruction
  | Zero (n : ℕ)
  | Succ (n : ℕ)
  | Jump (m n q : ℕ)

-- URM programs are lists of instructions
def URMProgram := List URMInstruction

namespace URMProgram

-- Length of a program (number of instructions)