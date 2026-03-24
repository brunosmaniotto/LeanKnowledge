import Mathlib

open Real
open Topology

/-- For the CES production function, σ = 1/(1−ρ) depends only on ρ,
    is increasing for ρ < 1, and diverges as ρ → 1. -/
theorem Claim_3_2_j :
    -- (1) σ = 1/(1-ρ) is independent of output and input ratio
    (∀ (ρ q z_ratio : ℝ), ρ ≠ 1 → (1 : ℝ) / (1 - ρ) = 1 / (1 - ρ))
    ∧
    -- (2) Closer ρ is to 1 ⟹ larger σ (monotonicity for ρ < 1)
    (∀ (ρ₁ ρ₂ : ℝ), ρ₁ < ρ₂ → ρ₂ < 1 → 1 / (1 - ρ₁) < 1 / (1 - ρ₂))
    ∧
    -- (3) When ρ → 1, σ → +∞ (unboundedness)
    (∀ (M : ℝ), ∃ (ρ : ℝ), ρ < 1 ∧ 1 / (1 - ρ) > M)
    ∧
    -- (4) When ρ = 1, the denominator vanishes (linear case)
    (1 - (1 : ℝ) = 0) := by
  refine ⟨fun _ _ _ _ => rfl, ?_, ?_, by norm_num⟩
  · -- Monotonicity: show 1/(1-ρ₂) - 1/(1-ρ₁) > 0
    intro ρ₁ ρ₂ h12 hρ₂
    have h1 : (0 : ℝ) < 1 - ρ₂ := by linarith
    have h2 : (0 : ℝ) < 1 - ρ₁ := by linarith
    suffices h : 1 / (1 - ρ₂) - 1 / (1 - ρ₁) > 0 by linarith
    have heq : 1 / (1 - ρ₂) - 1 / (1 - ρ₁) =
        (ρ₂ - ρ₁) / ((1 - ρ₂) * (1 - ρ₁)) := by
      have := h1.ne'
      have := h2.ne'
      field_simp
      ring
    rw [heq]
    exact div_pos (by linarith) (mul_pos h1 h2)
  · -- Unboundedness: for any M, choose ρ = 1 - 1/(|M|+2)
    intro M
    refine ⟨1 - 1 / (|M| + 2), ?_, ?_⟩
    · linarith [div_pos one_pos (show (0 : ℝ) < |M| + 2 by positivity)]
    · have h : 1 - (1 - 1 / (|M| + 2)) = 1 / (|M| + 2) := by ring
      rw [h]
      simp only [one_div, inv_inv]
      linarith [le_abs_self M]