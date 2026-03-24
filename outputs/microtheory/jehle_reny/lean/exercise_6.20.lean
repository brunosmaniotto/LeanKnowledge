import Mathlib
open scoped Classical

-- Import the necessary definitions from the prompt context
-- Definition of PreferenceRelation from Implicit_Def_1B_a
abbrev PreferenceRelation (X : Type*) := X → X → Prop

-- We use `variable` for the general context of the theorem
variable {I X : Type*} [Fintype I] [DecidableEq I] [Fintype X] [DecidableEq X]
variable (c : (I → PreferenceRelation X) → X)

/-- A preference relation where `s_top` is strictly preferred to all other states.
    `s_top R z` is true for all `z`. If `z ≠ s_top`, then `¬ (z R s_top)`. -/
def R_strictly_top (s_top : X) : PreferenceRelation X :=
  fun a b => a = s_top ∨ (a ≠ s_top ∧ a = b)