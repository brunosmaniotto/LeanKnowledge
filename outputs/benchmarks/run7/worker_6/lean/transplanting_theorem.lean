import Mathlib

variable {S T : Type} (f : S ≃ T) (op : S → S → S)

/-- The transplant of `op` under the bijection `f`. -/
def transplant : T → T → T := λ x y => f (op (f.symm x) (f.symm y))