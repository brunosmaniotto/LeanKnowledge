import Mathlib
open Topology

/-- Adverse selection: an informed agent's trading decision depends on private
    information in a way that adversely affects uninformed participants. -/
structure AdverseSelection (Agent : Type*) (Info : Type*) (Outcome : Type*) where
  /-- Whether an agent is informed (holds private information). -/
  informed : Agent → Prop
  /-- The private signal observed by an informed agent. -/
  privateSignal : Agent → Info
  /-- Trading decision given private information. -/
  tradingDecision : Agent → Info → Prop
  /-- Payoff to an uninformed participant given an outcome. -/
  uninformedPayoff : Outcome → ℝ
  /-- Outcome that results when an informed agent trades on signal `i`. -/
  outcomeFromTrade : Agent → Info → Outcome
  /-- The baseline payoff under symmetric (full) information. -/
  symmetricPayoff : Outcome → ℝ
  /-- Core property: an informed agent's decision to trade depends on her
      private signal — she trades when the signal is favourable to her. -/
  decision_depends_on_info :
    ∀ a, informed a →
      ∃ i₁ i₂ : Info, tradingDecision a i₁ ∧ ¬tradingDecision a i₂
  /-- Adverse effect: when an informed agent trades, the uninformed
      participant is worse off than under symmetric information. -/
  adverse_effect :
    ∀ a i, informed a → tradingDecision a i →
      uninformedPayoff (outcomeFromTrade a i) ≤ symmetricPayoff (outcomeFromTrade a i)