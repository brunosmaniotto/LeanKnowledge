import Mathlib
open Topology
open BigOperators

/-- Budget balancedness implies that if any single price or the consumer's income changes,
    the budget constraint y = Σ p_i x_i(p,y) must hold both before and after the change. -/
theorem Claim_1_5_3_b
    {n : ℕ}
    (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (budget_balanced : ∀ (p : Fin n → ℝ) (y : ℝ),
      y = ∑ i : Fin n, p i * x p y i)
    (p p' : Fin n → ℝ) (y y' : ℝ) :
    y = ∑ i : Fin n, p i * x p y i ∧
    y' = ∑ i : Fin n, p' i * x p' y' i := by
  exact ⟨budget_balanced p y, budget_balanced p' y'⟩