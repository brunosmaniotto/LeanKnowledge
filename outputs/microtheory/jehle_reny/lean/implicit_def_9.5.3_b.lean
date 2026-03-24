import Mathlib

/-- An incentive-compatible direct mechanism is ex post efficient if for every
    vector of reported types t, any alternative x receiving positive probability
    p_x(t) > 0 is ex post efficient when the vector of types is t. -/
def ExPostEfficientMechanism
    {T X : Type*}
    (p : T → X → ℝ)
    (exPostEff : T → X → Prop) : Prop :=
  ∀ t : T, ∀ x : X, p t x > 0 → exPostEff t x