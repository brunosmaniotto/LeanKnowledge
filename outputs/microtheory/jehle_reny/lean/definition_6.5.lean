import Mathlib

/-- A social choice function is strategy-proof if no agent can benefit by
    misreporting their preferences. For every agent i and every profile R,
    the outcome under truthful reporting c(R) is weakly preferred by i
    to the outcome c(R') under any unilateral deviation R' = (R̃ᵢ, R₋ᵢ). -/
def IsStrategyProof {I : Type*} {X : Type*} [DecidableEq I]
    (c : (I → X → X → Prop) → X) : Prop :=
  ∀ (i : I) (R : I → X → X → Prop) (Ri' : X → X → Prop),
    R i (c R) (c (Function.update R i Ri'))