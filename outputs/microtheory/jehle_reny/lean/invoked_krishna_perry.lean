import Mathlib

structure DirectMechanism (T : Type) (X : Type) where
  g : T → X
  c : T → ℝ

class IsIndividuallyRational {T X : Type} (M : DirectMechanism T X) : Prop where
  ir : ∀ t, M.c t ≤ 0

axiom Def_IR_VCG (T X : Type) : DirectMechanism T X

axiom Def_IR_VCG_is_IR {T X : Type} : IsIndividuallyRational (Def_IR_VCG T X)

theorem Invoked_Krishna_Perry (T X : Type) : IsIndividuallyRational (Def_IR_VCG T X) :=
  Def_IR_VCG_is_IR