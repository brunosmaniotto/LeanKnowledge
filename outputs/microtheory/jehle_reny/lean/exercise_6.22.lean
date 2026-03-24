import Mathlib
open Set Function

variable {I X : Type*} [Fintype I] [Fintype X] [DecidableEq I] [DecidableEq X] [Nonempty X]

-- Definition of a preference relation (a binary relation on X)
abbrev PreferenceRelation (X : Type*) := X → X → Prop

-- Definition of a profile of preference relations
abbrev PreferenceProfile (I X : Type*) := I → PreferenceRelation X

-- A relation is a strict ranking if it is asymmetric and transitive.
structure IsStrictRanking {X : Type*} (R : PreferenceRelation X) : Prop where
  asymm : ∀ x y, R x y → ¬ R y x
  trans : ∀ x y z, R x y → R y z → R x z

-- Definition based on Implicit_Def_6.5_a: A social choice function
-- The range condition "whose range is all of X" is crucial.
structure IsSocialChoiceFunction {I X : Type*} (c : PreferenceProfile I X → X) : Prop where
  range_all_of_X : ∀ x₀ : X, ∃ R : PreferenceProfile I X, c R = x₀

-- Definition 6.7: A social choice function c(·) is monotonic
structure IsMonotonic {I X : Type*} (c : PreferenceProfile I X → X) : Prop where
  monotonicity : ∀ (R_orig R_new : PreferenceProfile I X) (x : X),
    c R_orig = x →
    (∀ i : I, ∀ y : X, y ≠ x → R_orig i x y → R_new i x y) →
    c R_new = x

def R_strict_profile_def {I X : Type*} [DecidableEq X] (x₀ : X) : PreferenceProfile I X :=
  fun i a b => (a = x₀ ∧ b ≠ x₀)