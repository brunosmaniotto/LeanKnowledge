import Mathlib

structure OLGEconomy where
  utility : ℕ → ℝ → ℝ → ℝ
  endowmentYoung : ℕ → ℝ
  endowmentOld : ℕ → ℝ

structure WalrasianEquilibriumOLG (E : OLGEconomy) where
  price : ℕ → ℝ
  money : ℝ
  consumptionYoung : ℕ → ℝ
  consumptionOld : ℕ → ℝ
  money_nonneg : 0 ≤ money
  price_pos : ∀ t, 0 < price t
  utility_maximization : ∀ t (cb ca : ℝ),
    price t * cb + price (t + 1) * ca ≤
      price t * E.endowmentYoung t + price (t + 1) * E.endowmentOld t →
    E.utility t cb ca ≤ E.utility t (consumptionYoung t) (consumptionOld t)
  feasibility_first : consumptionYoung 0 = 1
  feasibility : ∀ t, consumptionOld t + consumptionYoung (t + 1) = 1