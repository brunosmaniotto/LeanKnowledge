import Mathlib
open BigOperators

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {L : Type*} [Fintype L]

/-- A pure exchange economy with agents I and goods L -/
structure ExchangeEconomy (I L : Type*) [Fintype I] [Fintype L] where
  endowment : I → (L → ℝ)
  strictPref : I → (L → ℝ) → (L → ℝ) → Prop
  pref_exceeds_budget : ∀ (p : L → ℝ) (i : I) (xStar xi : L → ℝ),
    (∀ l, 0 < p l) →
    (∑ l, p l * xStar l ≤ ∑ l, p l * endowment i l) →
    strictPref i xi xStar →
    ∑ l, p l * xi l > ∑ l, p l * endowment i l

structure WalrasianEquilibrium (E : ExchangeEconomy I L) where
  allocation : I → (L → ℝ)
  prices : L → ℝ
  prices_pos : ∀ l, 0 < prices l
  budget_feasible : ∀ i, ∑ l, prices l * allocation i l ≤ ∑ l, prices l * E.endowment i l
  market_clearing : ∀ l, ∑ i, allocation i l = ∑ i, E.endowment i l

def CoreProperty (E : ExchangeEconomy I L) (x : I → (L → ℝ)) : Prop :=
  ∀ (S : Finset I), S.Nonempty →
    ∀ (y : I → (L → ℝ)),
      (∀ i ∈ S, E.strictPref i (y i) (x i)) →
      ¬(∀ l, ∑ i ∈ S, y i l ≤ ∑ i ∈ S, E.endowment i l)