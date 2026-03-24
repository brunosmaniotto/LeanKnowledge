import Mathlib

variable {S T : Type*} (R : Set (S × T))

def one_to_many : Prop := ∀ (t : T) (s1 s2 : S), (s1, t) ∈ R → (s2, t) ∈ R → s1 = s2