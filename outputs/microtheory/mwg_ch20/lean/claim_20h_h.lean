import Mathlib

theorem olg_monetary_equilibrium_constant_money
    (p : ℕ → ℝ) (c_a c_b : ℕ → ℝ) (M : ℝ)
    (hM : M > 0)
    (h_budget_young : ∀ t, p t * (1 - c_a t) = M)
    (h_budget_old : ∀ t, p (t + 1) * c_b (t + 1) = M)
    (h_clearing : ∀ t, c_a t + c_b t = 1) :
    (∀ t, p t * c_b t = M) ∧
    (∀ t, p (t + 1) * c_b (t + 1) = M) ∧
    (M ≠ 0) := by
  refine ⟨?_, h_budget_old, ?_⟩
  · intro t
    have hclear := h_clearing t
    have hbudget := h_budget_young t
    have : c_b t = 1 - c_a t := by linarith
    rw [this]
    exact hbudget
  · linarith