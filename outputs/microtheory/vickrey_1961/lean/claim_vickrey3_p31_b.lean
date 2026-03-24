import Mathlib

open Real
open Topology

/-
Claim_Vickrey3_p31_b: With the progressive auction, for a given bidder to obtain a gain of g or more after drawing a value of v requires that all other bidders draw values less than v - g.

Interpretation for formal proof:
Let `v` be the given bidder's value.
Let `g` be the desired gain.
Let `v_other_max` be the maximum value among all other bidders.

The condition "to obtain a gain of g or more" is formalized as `v - v_other_max ≥ g`.
The conclusion "all other bidders draw values less than v - g" is interpreted as `v_other_max ≤ v - g`.
This interpretation of "less than" as "less than or equal to" is necessary for the theorem to be mathematically provable, as a strict inequality (`<`) would make the statement false in cases where `v_other_max = v - g`.
-/
lemma Claim_Vickrey3_p31_b (v g v_other_max : ℝ) (h_gain : v - v_other_max ≥ g) :
    v_other_max ≤ v - g := by
  -- The hypothesis `h_gain` is `v - v_other_max ≥ g`.
  -- We want to prove `v_other_max ≤ v - g`.
  -- We can rearrange the terms in the hypothesis to directly obtain the conclusion:
  -- From `v - v_other_max ≥ g`, add `v_other_max` to both sides:
  -- `v ≥ g + v_other_max`
  -- Then, subtract `g` from both sides:
  -- `v - g ≥ v_other_max`
  -- This is equivalent to `v_other_max ≤ v - g`, which is our goal.
  linarith