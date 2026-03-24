import Mathlib

open Subsemigroup

variable (S : Type _) [CommSemigroup S]
variable (T : Type _) [CommGroup T]
variable (ι : MulHom S T)

def IsCancellable (x : S) : Prop := ∀ a b, x * a = x * b → a = b