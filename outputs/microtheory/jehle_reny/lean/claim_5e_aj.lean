import Mathlib
open BigOperators

variable {I : Type*} [Fintype I] [Nonempty I] {L : ℕ}

structure ExchangeEconomy (I : Type*) (L : ℕ) where
  utility : I → (Fin L → ℝ) → ℝ
  endowment : I → Fin L → ℝ

def StrictlyPositiveAggregate (E : ExchangeEconomy I L) : Prop :=
  ∀ l : Fin L, 0 < ∑ i : I, E.endowment i l

axiom Assumption5_1 : ExchangeEconomy I L → Prop