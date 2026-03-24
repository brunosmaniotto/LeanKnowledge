import Mathlib

open AddSubgroup

noncomputable def external_iso : ZMod 2 × ZMod 3 ≃+ ZMod 6 :=
  (ZMod.chineseRemainder (by norm_num : Nat.Coprime 2 3)).symm.toAddEquiv

def H2 : AddSubgroup (ZMod 6) := zmultiples (3 : ZMod 6)