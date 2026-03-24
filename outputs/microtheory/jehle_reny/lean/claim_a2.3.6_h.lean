import Mathlib
open Topology

/-- When KKT (Theorem A2.20) is applied with non-negativity constraints g_i(x) = -x_i ≤ 0,
    the KKT conditions (Df_i = -μ_i, μ_i ≥ 0, μ_i x_i = 0, x_i ≥ 0)
    are equivalent to Theorem A2.19: Df_i ≤ 0, x_i ≥ 0, x_i Df_i = 0. -/
theorem Claim_A2_3_6_h {n : ℕ} (Df : Fin n → ℝ) (x : Fin n → ℝ) :
    (∃ μ : Fin n → ℝ, (∀ i, 0 ≤ μ i) ∧ (∀ i, Df i = -(μ i)) ∧
      (∀ i, μ i * x i = 0) ∧ (∀ i, 0 ≤ x i))
    ↔
    ((∀ i, Df i ≤ 0) ∧ (∀ i, 0 ≤ x i) ∧ (∀ i, x i * Df i = 0)) := by
  constructor
  · rintro ⟨μ, hμ_nn, hDf, hcompl, hx_nn⟩
    refine ⟨fun i => ?_, hx_nn, fun i => ?_⟩
    · linarith [hDf i, hμ_nn i]
    · have h : x i * Df i = -(μ i * x i) := by rw [hDf i]; ring
      linarith [hcompl i]
  · rintro ⟨hDf_le, hx_nn, hcompl⟩
    refine ⟨fun i => -(Df i), fun i => ?_, fun i => ?_, fun i => ?_, hx_nn⟩
    · linarith [hDf_le i]
    · ring
    · have h : -(Df i) * x i = -(x i * Df i) := by ring
      linarith [hcompl i]