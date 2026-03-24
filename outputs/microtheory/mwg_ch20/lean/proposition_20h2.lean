import Mathlib
open BigOperators

theorem Proposition_20H2
    (p : ℕ → ℝ) (M : ℝ)
    (hM_nonneg : 0 ≤ M)
    (h_summable : Summable p)
    (hp_nonneg : ∀ t, 0 ≤ p t)
    (h_wealth : ∀ S, S = ∑' t, p t → S + M ≤ S) :
    M = 0 := by
  have hS := h_wealth (∑' t, p t) rfl
  linarith