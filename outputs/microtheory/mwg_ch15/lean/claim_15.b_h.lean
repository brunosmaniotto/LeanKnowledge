import Mathlib

/-!
# Second Fundamental Theorem of Welfare Economics (Edgeworth Box)
-/

noncomputable section

open Set

abbrev Bundle := Fin 2 → ℝ

structure Preference where
  le : Bundle → Bundle → Prop

def Preference.IsContinuous (p : Preference) : Prop :=
  ∀ y, IsClosed {x : Bundle | p.le y x} ∧ IsClosed {x : Bundle | p.le x y}