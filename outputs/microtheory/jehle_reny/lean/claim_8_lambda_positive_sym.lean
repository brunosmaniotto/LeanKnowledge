import Mathlib
open Topology

theorem claim_8_lambda_positive_sym
    (L : ℕ)
    (u' : ℝ → ℝ)
    (w p : ℝ)
    (B : Fin (L + 1) → ℝ)
    (lam : ℝ)
    (hu'_pos : ∀ x, 0 < u' x)
    (hu'_strict_anti : StrictAnti u')
    (hfoc : ∀ l : Fin (L + 1), lam * u' (w - p - ↑l + B l) = 1) :
    0 < lam ∧
    (∀ l : Fin (L + 1), u' (w - p - ↑l + B l) = 1 / lam) ∧
    (∀ l₁ l₂ : Fin (L + 1), B l₁ - ↑l₁ = B l₂ - ↑l₂) := by
  have hlam_pos : 0 < lam := by
    have h := hfoc 0
    have hup := hu'_pos (w - p - ↑(0 : Fin (L + 1)) + B 0)
    nlinarith
  have hlam_ne : lam ≠ 0 := hlam_pos.ne'
  refine ⟨hlam_pos, fun l => ?_, fun l₁ l₂ => ?_⟩
  · rw [eq_div_iff hlam_ne, mul_comm]
    exact hfoc l
  · have heq : u' (w - p - ↑l₁ + B l₁) = u' (w - p - ↑l₂ + B l₂) := by
      have h1 := hfoc l₁
      have h2 := hfoc l₂
      exact mul_left_cancel₀ hlam_ne (by linarith)
    linarith [hu'_strict_anti.injective heq]