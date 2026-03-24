import Mathlib
open BigOperators

-- Walrasian equilibrium and core property for a pure exchange economy
-- We axiomatize the economic primitives and prove the logical structure

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {L : Type*} [Fintype L]

/-- A pure exchange economy with agents I and goods L -/
structure ExchangeEconomy (I L : Type*) [Fintype I] [Fintype L] where
  /-- Endowment of agent i -/
  endowment : I → (L → ℝ)
  /-- Strict preference: agent i strictly prefers x to y -/
  strictPref : I → (L → ℝ) → (L → ℝ) → Prop
  /-- If x is strictly preferred to the optimum at prices p, then x costs more -/
  pref_exceeds_budget : ∀ (p : L → ℝ) (i : I) (xStar xi : L → ℝ),
    (∀ l, 0 < p l) →
    (∑ l, p l * xStar l ≤ ∑ l, p l * endowment i l) →
    strictPref i xi xStar →
    ∑ l, p l * xi l > ∑ l, p l * endowment i l

/-- A Walrasian equilibrium allocation -/
structure WalrasianEquilibrium (E : ExchangeEconomy I L) where
  allocation : I → (L → ℝ)
  prices : L → ℝ
  prices_pos : ∀ l, 0 < prices l
  budget_feasible : ∀ i, ∑ l, prices l * allocation i l ≤ ∑ l, prices l * E.endowment i l
  market_clearing : ∀ l, ∑ i, allocation i l = ∑ i, E.endowment i l

/-- The core property: no coalition can block the allocation -/
def CoreProperty (E : ExchangeEconomy I L) (x : I → (L → ℝ)) : Prop :=
  ∀ (S : Finset I), S.Nonempty →
    ∀ (y : I → (L → ℝ)),
      (∀ i ∈ S, E.strictPref i (y i) (x i)) →
      ¬(∀ l, ∑ i ∈ S, y i l ≤ ∑ i ∈ S, E.endowment i l)