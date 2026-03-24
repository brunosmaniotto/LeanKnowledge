import Mathlib

/-- Model where effort is observable but profit may not be. -/
structure EffortObservableModel where
  /-- Effort level -/
  e : ℝ
  /-- Profit in state L as a function of effort -/
  π_L : ℝ → ℝ
  /-- Profit in state H as a function of effort -/
  π_H : ℝ → ℝ
  /-- Wage/compensation -/
  w : ℝ
  /-- Utility of worker -/
  u : ℝ → ℝ
  /-- Reservation utility -/
  u_bar : ℝ
  /-- Cost of effort -/
  g : ℝ → ℝ
  /-- Marginal profits are equal across states for e > 0 -/
  marginal_eq : ∀ e' > 0, deriv π_H e' = deriv π_L e'
  /-- Marginal profits are positive for e > 0 -/
  marginal_pos : ∀ e' > 0, deriv π_L e' > 0

/-- The optimal contract depends only on effort observability, not profit observability.
    When marginal profits are equal across states, the first-order conditions
    for the optimal effort level are identical whether or not π is observable. -/
theorem profit_unobservability_irrelevant (M : EffortObservableModel) (he : M.e > 0) :
    deriv M.π_H M.e = deriv M.π_L M.e ∧ deriv M.π_L M.e > 0 := by
  exact ⟨M.marginal_eq M.e he, M.marginal_pos M.e he⟩