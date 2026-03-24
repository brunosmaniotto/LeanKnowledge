import Mathlib

variable {S T : Type*}

def R_f (f : S → T) : Setoid S :=
  { r := fun x y => f x = f y
    iseqv := ⟨
      fun x => rfl,
      fun h => h.symm,
      fun h₁ h₂ => h₁.trans h₂⟩ }