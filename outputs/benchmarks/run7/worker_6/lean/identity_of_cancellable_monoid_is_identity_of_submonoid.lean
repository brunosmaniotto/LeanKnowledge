import Mathlib

variable {S : Type u} [Monoid S] [IsCancelMul S]

theorem identity_of_cancellative_submonoid (T : Submonoid S) : ((1 : T) : S) = 1 :=
  rfl