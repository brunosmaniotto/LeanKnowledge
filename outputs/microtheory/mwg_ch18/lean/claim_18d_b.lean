import Mathlib
open BigOperators

variable {I L : Type*} [Fintype I] [Fintype L]

structure WalrasianEquilibrium (I L : Type*) [Fintype I] [Fintype L] where
  price : L → ℝ
  allocation : I → L → ℝ
  endowment : I → L → ℝ
  utility : I → (L → ℝ) → ℝ
  budget_feasible : ∀ i, ∑ l, price l * (allocation i l - endowment i l) ≤ 0
  utility_maximized : ∀ i (x' : L → ℝ), (∑ l, price l * (x' l - endowment i l) ≤ 0) →
    utility i x' ≤ utility i (allocation i)

def ParetoOptimal {I L : Type*} [Fintype I] [Fintype L]
    (utility : I → (L → ℝ) → ℝ) (alloc : I → L → ℝ) : Prop :=
  ¬∃ (alloc' : I → L → ℝ), (∀ i, utility i (alloc i) ≤ utility i (alloc' i)) ∧
    (∃ i, utility i (alloc i) < utility i (alloc' i))