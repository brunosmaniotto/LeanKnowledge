import Mathlib

variable {S T : Type} [CommSemigroup S] [CommGroup T] (ι : MulHom S T) (hι : Function.Injective ι)
variable (C : Set S)

def f (x : S) (y : C) : T := ι x * (ι (y : S))⁻¹