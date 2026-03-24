import Mathlib

open Equiv

variable {α : Type _} (π : Perm α)

/-- The relation induced by powers of a permutation. -/
def R (i j : α) : Prop := ∃ (k : ℤ), (π ^ k) i = j