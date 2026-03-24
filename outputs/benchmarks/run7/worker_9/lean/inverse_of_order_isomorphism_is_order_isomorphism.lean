import Mathlib

variable {S T : Type _} [LE S] [LE T]

def inverse_of_order_iso_is_order_iso (φ : S ≃o T) : T ≃o S := φ.symm