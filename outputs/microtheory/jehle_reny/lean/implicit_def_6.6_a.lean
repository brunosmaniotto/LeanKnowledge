import Mathlib
open Topology

/-- A lexicographic dictatorship: rank alternatives by individual 1's preference,
    breaking indifference by individual 2's preference, and so on. -/
def lexicographicDictatorship {X : Type*} (prefs : List (X → X → Prop))
    [∀ R : X → X → Prop, DecidableRel R] (x y : X) : Prop :=
  match prefs with
  | [] => True  -- if all individuals are indifferent, declare indifference (weak preference)
  | R :: rest =>
    if R x y ∧ ¬R y x then True        -- strict preference by this individual
    else if R y x ∧ ¬R x y then False   -- strict reverse preference
    else lexicographicDictatorship rest x y  -- indifferent, defer to next individual