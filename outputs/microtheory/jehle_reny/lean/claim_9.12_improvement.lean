import Mathlib
set_option linter.unusedVariables false

theorem Claim_9_12_improvement (N : ℕ) (hN : N > 0) (S : ℝ) (hS : 0 ≤ S)
    (T : Type*) (u_old u_new : Fin N → T → ℝ)
    (h_utility : ∀ i t, u_new i t = u_old i t + (1 / (N : ℝ)) * S)
    (balanced_budget_new : Prop) (h_balanced : balanced_budget_new) :
    (∀ i t, u_old i t ≤ u_new i t) ∧ balanced_budget_new := by
  constructor
  · intro i t
    rw [h_utility i t]
    have h_div : 0 ≤ 1 / (N : ℝ) :=
      div_nonneg (by norm_num) (mod_cast le_of_lt hN)
    have h_term : 0 ≤ (1 / (N : ℝ)) * S :=
      mul_nonneg h_div hS
    linarith
  · exact h_balanced