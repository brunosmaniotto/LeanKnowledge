import Mathlib
open Topology

/-- Adverse selection (MWG 13.B): an informed individual's trading decision
    depends on her unobservable characteristics θ in a manner that adversely
    affects uninformed agents. In the labor market context, r(θ) is worker
    productivity and the average productivity of workers willing to accept
    employment depends on the offered wage. -/
structure AdverseSelection (Θ : Type*) where
  /-- Productivity or quality of type θ, unobservable to uninformed agents -/
  r : Θ → ℝ
  /-- Trading decision: whether the informed agent of type θ accepts terms w -/
  accepts : Θ → ℝ → Prop
  /-- The trading decision depends on the unobservable type θ -/
  selection_depends_on_type : ∃ w θ₁ θ₂, accepts θ₁ w ∧ ¬ accepts θ₂ w
  /-- Payoff to the uninformed side from transacting with type θ at terms w -/
  uninformed_payoff : Θ → ℝ → ℝ
  /-- The selection pattern adversely affects uninformed agents:
      there exist terms where an accepting type imposes a loss -/
  adverse_to_uninformed : ∃ w θ, accepts θ w ∧ uninformed_payoff θ w < 0