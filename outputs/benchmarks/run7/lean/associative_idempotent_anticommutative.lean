import Mathlib

variable {S : Type} (op : S → S → S)

def Associative : Prop := ∀ a b c, op (op a b) c = op a (op b c)