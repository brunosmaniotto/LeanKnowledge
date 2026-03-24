import Mathlib
open Finset BigOperators Nat

-- Individuals and alternatives
variable {I : Type*} [Fintype I] [DecidableEq I]
variable (h_card_I_odd : Odd (Fintype.card I))
-- For non-dictatorial property, we need at least 3 individuals (odd and > 2 implies >=3).
variable (h_card_I_ge_three : 2 < Fintype.card I)

-- Alternatives are 0 and 1.
abbrev X := Fin 2

-- A preference relation for an individual is determined by their top choice.
-- `ind_pref top_choice x y` means `x` is preferred to `y` according to `top_choice`.
def ind_pref (top_choice : X) (x y : X) : Prop :=
  (x = top_choice ∧ y ≠ top_choice) ∨ (x = y)

-- A preference profile maps each individual to their top choice.
abbrev PreferenceProfile := I → X

-- Helper: Count votes for a given alternative