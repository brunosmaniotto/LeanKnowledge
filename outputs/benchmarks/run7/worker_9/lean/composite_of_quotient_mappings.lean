import Mathlib

open Setoid

variable {S : Type*} (r1 : Setoid S) (r2 : Setoid (Quotient r1))

noncomputable section

def f : S → Quotient r2 := fun x => Quotient.mk r2 (Quotient.mk r1 x)