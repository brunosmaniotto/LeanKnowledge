import Mathlib

open Finset BigOperators
open BigOperators

/-- An exchange economy with finitely many consumers and L commodities -/
structure ExchangeEconomy (I : Type*) [Fintype I] (L : ℕ) where
  endowment : I → Fin L → ℝ
  strictPref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop

abbrev Allocation (I : Type*) (L : ℕ) := I → Fin L → ℝ

def isFeasible {I : Type*} [Fintype I] {L : ℕ}
    (E : ExchangeEconomy I L) (x : Allocation I L) : Prop :=
  (∀ i l, 0 ≤ x i l) ∧
  ∀ l : Fin L, ∑ i, x i l = ∑ i, E.endowment i l