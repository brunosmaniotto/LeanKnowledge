import Mathlib

-- Define the type for the parity group
inductive Parity
  | even
  | odd

namespace Parity

-- Define the group operations
def mul : Parity → Parity → Parity
  | even, even => even
  | even, odd => odd
  | odd, even => odd
  | odd, odd => even