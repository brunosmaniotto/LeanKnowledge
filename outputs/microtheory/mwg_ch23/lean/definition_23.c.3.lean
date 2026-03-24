import Mathlib

/-- A social choice function is truthfully implementable in dominant strategies
(strategy-proof) if truthful reporting is a dominant strategy for every agent.
That is, for every agent i, reporting their true type θ_i yields at least as
high utility as any misreport, regardless of others' reports. -/
def IsTruthfullyImplementable
    {I : Type*} [Fintype I] [DecidableEq I]
    {Theta : I → Type*}
    {X : Type*}
    (f : (∀ i, Theta i) → X)
    (u : I → X → (∀ i, Theta i) → ℝ)
    : Prop :=
  ∀ (i : I) (theta : ∀ i, Theta i) (thetaHat : Theta i),
    u i (f theta) theta ≥ u i (f (Function.update theta i thetaHat)) theta