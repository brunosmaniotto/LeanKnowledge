import Mathlib

variable {S T : Type}

def renaming_mapping (f : S → T) : Quotient (Setoid.ker f) → Set.range f :=
  Quotient.lift (fun x : S => ⟨f x, x, rfl⟩) (fun x y h => Subtype.ext h)