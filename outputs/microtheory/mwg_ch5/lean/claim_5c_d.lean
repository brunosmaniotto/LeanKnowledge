import Mathlib

open Finset BigOperators
open BigOperators

/-- Single-output technology: production function f : ℝ^L → ℝ with gradient. -/
structure SingleOutputTech (L : ℕ) where
  f : (Fin L → ℝ) → ℝ
  gradient : (Fin L → ℝ) → (Fin L → ℝ)

/-- Profit function: p * f(z) - w · z -/
noncomputable def profit {L : ℕ} (tech : SingleOutputTech L) (p : ℝ) (w : Fin L → ℝ)
    (z : Fin L → ℝ) : ℝ :=
  p * tech.f z - ∑ l : Fin L, w l * z l

/-- First-order conditions for profit maximization with non-negativity constraints:
    (i)  p * ∂f/∂z_ℓ ≤ w_ℓ for all ℓ
    (ii) z*_ℓ > 0 → p * ∂f/∂z_ℓ = w_ℓ  (complementary slackness)
    Combined: [p∇f(z*) - w] · z* = 0 -/
structure ProfitFOC {L : ℕ} (tech : SingleOutputTech L) (p : ℝ) (w : Fin L → ℝ)
    (zStar : Fin L → ℝ) : Prop where
  nonneg : ∀ l, 0 ≤ zStar l
  grad_le : ∀ l, p * tech.gradient zStar l ≤ w l
  compl_slack : ∀ l, 0 < zStar l → p * tech.gradient zStar l = w l
  dot_zero : ∑ l : Fin L, (p * tech.gradient zStar l - w l) * zStar l = 0

/-- The complementary slackness conditions (grad_le + compl_slack + nonneg)
    imply the dot product condition [p∇f(z*) - w] · z* = 0. -/
theorem Claim_5C_d {L : ℕ} (tech : SingleOutputTech L) (p : ℝ) (w : Fin L → ℝ)
    (zStar : Fin L → ℝ)
    (h_nonneg : ∀ l, 0 ≤ zStar l)
    (h_grad_le : ∀ l, p * tech.gradient zStar l ≤ w l)
    (h_compl : ∀ l, 0 < zStar l → p * tech.gradient zStar l = w l) :
    ProfitFOC tech p w zStar := by
  refine ⟨h_nonneg, h_grad_le, h_compl, ?_⟩
  apply Finset.sum_eq_zero
  intro l _
  by_cases hz : zStar l = 0
  · simp [hz]
  · have hpos : 0 < zStar l := lt_of_le_of_ne (h_nonneg l) (Ne.symm hz)
    have heq := h_compl l hpos
    simp [heq]