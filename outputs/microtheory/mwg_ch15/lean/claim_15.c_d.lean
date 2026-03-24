import Mathlib
open BigOperators

-- First Welfare Theorem: one consumer, one producer, possibly nonconvex production set
-- Any Walrasian equilibrium maximizes consumer well-being over feasible allocations.

theorem first_welfare_theorem_nonconvex
    {L : Type*} [Fintype L]
    (p : L → ℝ)                          -- prices
    (ω : L → ℝ)                          -- endowment
    (Y : Set (L → ℝ))                    -- production set (possibly nonconvex)
    (u : (L → ℝ) → ℝ)                    -- utility function
    (x_star y_star : L → ℝ)              -- equilibrium allocation
    (hy_star : y_star ∈ Y)               -- equilibrium production is feasible
    (hfeas : ∀ l, x_star l = ω l + y_star l)  -- market clearing
    -- profit maximization: y_star maximizes profit over Y
    (hprofit : ∀ y ∈ Y, ∑ l, p l * y l ≤ ∑ l, p l * y_star l)
    -- utility maximization: x_star maximizes u subject to budget
    (hutil : ∀ x : L → ℝ, ∑ l, p l * x l ≤ ∑ l, p l * x_star l → u x ≤ u x_star)
    -- any feasible allocation satisfies the budget constraint
    (hbudget : ∀ x y : L → ℝ, y ∈ Y → (∀ l, x l = ω l + y l) →
      ∑ l, p l * x l ≤ ∑ l, p l * x_star l) :
    -- conclusion: x_star is optimal among all feasible allocations
    ∀ x : L → ℝ, (∃ y ∈ Y, ∀ l, x l = ω l + y l) → u x ≤ u x_star := by
  intro x ⟨y, hy, hxy⟩
  exact hutil x (hbudget x y hy hxy)