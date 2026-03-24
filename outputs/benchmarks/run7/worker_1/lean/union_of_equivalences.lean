import Mathlib.Data.Rel

-- Define the set S = {a, b, c}
inductive S
  | a
  | b
  | c

open S

-- Define the first equivalence relation: {a,b} and {c}
def R1 : S → S → Prop :=
  fun x y => (x = y) ∨ (x = a ∧ y = b) ∨ (x = b ∧ y = a)

-- Prove R1 is an equivalence relation