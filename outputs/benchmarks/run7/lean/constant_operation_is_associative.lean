import Mathlib

variable {S : Type} (c : S)

def const_op : S → S → S := λ _ _ => c