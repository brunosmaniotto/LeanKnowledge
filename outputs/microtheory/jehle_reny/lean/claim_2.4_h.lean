import Mathlib

/-- If preferences are represented by a utility function with the expected utility property,
    then the individual is an expected utility maximizer: he chooses one gamble over another
    iff the expected utility of the one exceeds that of the other. -/
theorem Claim_2_4_h
    {Gamble : Type*}
    (eu : Gamble → ℝ)
    (prefers : Gamble → Gamble → Prop)
    (representation : ∀ g g' : Gamble, prefers g g' ↔ eu g ≥ eu g') :
    ∀ g g' : Gamble, prefers g g' ↔ eu g ≥ eu g' :=
  representation