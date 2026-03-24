import Mathlib

open Finset BigOperators

variable {X : Type*} [Fintype X] [DecidableEq X]
variable {I : Type*} [Fintype I] [DecidableEq I]

/-- Borda score: number of alternatives that i strictly prefers x over. -/
def bordaScore (pref : I → X → X → Prop) [∀ i, DecidableRel (pref i)] (i : I) (x : X) : ℕ :=
  (Finset.univ.filter (fun y => pref i x y)).card