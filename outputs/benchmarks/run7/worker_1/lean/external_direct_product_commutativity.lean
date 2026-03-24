import Mathlib

variable {S T : Type _}

def prod_op (op1 : S → S → S) (op2 : T → T → T) : (S × T) → (S × T) → (S × T) :=
  fun a b => (op1 a.1 b.1, op2 a.2 b.2)