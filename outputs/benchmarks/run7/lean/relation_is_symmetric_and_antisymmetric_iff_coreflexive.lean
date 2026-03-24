import Mathlib
open Set

variable {α : Type u}

def SymmetricSet (r : Set (α × α)) : Prop := ∀ (x y : α), (x, y) ∈ r → (y, x) ∈ r