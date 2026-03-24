import Mathlib

open Set

variable {α : Type _}

def PowerSet (S : Set α) : Type _ := {A : Set α // A ⊆ S}

namespace PowerSet

variable (S : Set α)

instance : Mul (PowerSet S) where
  mul A B := ⟨A.1 ∪ B.1, by
    intro x hx
    rcases hx with (hx | hx)
    · exact A.2 hx
    · exact B.2 hx⟩

instance : One (PowerSet S) where
  one := ⟨∅, by simp⟩