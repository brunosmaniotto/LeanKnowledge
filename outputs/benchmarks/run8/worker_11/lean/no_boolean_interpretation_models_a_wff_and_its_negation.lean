import Mathlib
open Finset BigOperators

def PropForm (α : Type) := (α → Bool) → Bool

namespace PropForm

def var (x : α) : PropForm α := fun v => v x