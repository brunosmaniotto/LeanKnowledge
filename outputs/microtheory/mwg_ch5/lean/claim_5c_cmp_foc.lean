import Mathlib

open Finset BigOperators
open BigOperators

structure CMP_FOC (L : ℕ) where
  w : Fin L → ℝ
  zStar : Fin L → ℝ
  gradF : Fin L → ℝ
  mu : ℝ
  mu_nonneg : 0 ≤ mu
  foc_ineq : ∀ ℓ : Fin L, mu * gradF ℓ ≤ w ℓ
  zStar_nonneg : ∀ ℓ : Fin L, 0 ≤ zStar ℓ
  compl_slack : ∀ ℓ : Fin L, (w ℓ - mu * gradF ℓ) * zStar ℓ = 0

theorem cmp_foc_dot_product {L : ℕ} (foc : CMP_FOC L) :
    ∑ ℓ : Fin L, (foc.w ℓ - foc.mu * foc.gradF ℓ) * foc.zStar ℓ = 0 := by
  apply Finset.sum_eq_zero
  intro ℓ _
  exact foc.compl_slack ℓ