import Mathlib.Data.Set.Basic

open Set

variable {S : Type*}

def reflexive (R : Set (S × S)) : Prop := ∀ x, (x, x) ∈ R