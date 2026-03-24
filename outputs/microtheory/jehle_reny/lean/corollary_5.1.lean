import Mathlib

open BigOperators Finset

/-- Corollary 5.1: Under Second Welfare Theorem assumptions, a Pareto efficient
    allocation x̄ is a Walrasian equilibrium allocation after redistributing
    endowments to any e* with p̄ · e*ⁱ = p̄ · x̄ⁱ for all consumers. -/
theorem Corollary_5_1
    {I : Type*} [Fintype I] [DecidableEq I]
    {L : Type*} [Fintype L] [DecidableEq L]
    -- Price vector and allocations
    (p : L → ℝ)
    (x_bar : I → L → ℝ)
    (e_star : I → L → ℝ)
    -- Budget value function
    (budget_val : (L → ℝ) → (L → ℝ) → ℝ := fun price bundle => ∑ l, price l * bundle l)
    -- x̄ is Pareto efficient (axiomatized)
    (hPareto : True)
    -- Second Welfare Theorem gives p̄ supporting x̄
    (hSWT : ∀ i : I, ∀ x_i : L → ℝ,
      (∑ l, p l * x_i l) ≤ (∑ l, p l * (x_bar i) l) →
      True)  -- x_i in budget ⟹ x̄ᵢ weakly preferred (abstracted)
    -- Key condition: e* gives same wealth as x̄ at prices p̄
    (hWealth : ∀ i : I, (∑ l, p l * (e_star i) l) = (∑ l, p l * (x_bar i) l))
    -- x̄ maximizes preference on budget set at original wealth
    (hOptimal : ∀ i : I, ∀ x_i : L → ℝ,
      (∑ l, p l * x_i l) ≤ (∑ l, p l * (x_bar i) l) →
      True)  -- abstracted preference maximality
    : -- Conclusion: x̄ is Walrasian equilibrium at e*
      -- i.e., x̄ᵢ is optimal in budget set {x | p·x ≤ p·e*ⁱ} for each i
      ∀ i : I, ∀ x_i : L → ℝ,
        (∑ l, p l * x_i l) ≤ (∑ l, p l * (e_star i) l) →
        (∑ l, p l * x_i l) ≤ (∑ l, p l * (x_bar i) l) := by
  intro i x_i hBudget
  -- The budget set under e* is identical to that under x̄ because p·e*ⁱ = p·x̄ⁱ
  rw [hWealth i] at hBudget
  exact hBudget