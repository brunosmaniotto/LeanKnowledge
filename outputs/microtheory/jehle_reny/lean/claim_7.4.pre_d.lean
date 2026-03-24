import Mathlib
open Finset
open BigOperators

namespace Claim_7_4

variable {X : Type} [Fintype X] (r : X → X → Prop) [DecidableRel r] (p : X → ℝ)

/-- The belief system determined by Bayes' rule from node probabilities `p` and
    information set relation `r`. -/
noncomputable def belief (x : X) : ℝ :=
  p x / ∑ y ∈ univ.filter (r x), p y

theorem belief_spec (x : X) : belief r p x = p x / ∑ y ∈ univ.filter (r x), p y :=
  rfl