import Mathlib

/-- An extensive form game (axiomatized interface). -/
axiom ExtGame : Type

/-- A joint behavioural strategy in an extensive form game. -/
axiom BehaviouralStrategy : ExtGame → Type

/-- A system of beliefs in an extensive form game. -/
axiom BeliefSystem : ExtGame → Type

/-- Whether an assessment (beliefs, strategy) is sequentially rational. -/
axiom IsSequentiallyRationalAssessment :
  ∀ (Γ : ExtGame), BeliefSystem Γ → BehaviouralStrategy Γ → Prop

/-- A joint behavioural strategy `b` is **sequentially rational** if there exists
    some system of beliefs `p` such that the assessment `(p, b)` is sequentially
    rational (Definition 7.4.SR_c, Jehle & Reny). -/
def IsSequentiallyRational (Γ : ExtGame) (b : BehaviouralStrategy Γ) : Prop :=
  ∃ p : BeliefSystem Γ, IsSequentiallyRationalAssessment Γ p b