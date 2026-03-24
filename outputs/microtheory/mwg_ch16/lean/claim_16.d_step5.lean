import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_16D_step5
    {n : ℕ} {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (p : E →L[ℝ] ℝ) (r : ℝ) (x : Fin n → E)
    (h_approx : ∀ ε > 0, ∃ y : Fin n → E,
      (∀ i, ‖y i - x i‖ < ε) ∧ p (∑ i, y i) ≥ r) :
    p (∑ i, x i) ≥ r := by
  by_contra h_neg
  push_neg at h_neg
  have hgap : 0 < r - p (∑ i, x i) := by linarith
  by_cases hC : ‖p‖ = 0
  · have hp0 : p = 0 := norm_eq_zero.mp hC
    obtain ⟨y, _, hy_ge⟩ := h_approx 1 one_pos
    simp only [hp0, ContinuousLinearMap.zero_apply] at hy_ge h_neg
    linarith
  · have hC_pos : 0 < ‖p‖ := lt_of_le_of_ne (norm_nonneg p) (Ne.symm hC)
    have hdenom_pos : 0 < ‖p‖ * ↑n + 1 := by positivity
    let ε := (r - p (∑ i, x i)) / (‖p‖ * ↑n + 1)
    have hε_pos : 0 < ε := div_pos hgap hdenom_pos
    obtain ⟨y, hy_close, hy_ge⟩ := h_approx ε hε_pos
    have sum_close : ‖(∑ i, y i) - (∑ i, x i)‖ ≤ ↑n * ε := by
      calc ‖(∑ i, y i) - (∑ i, x i)‖
          = ‖∑ i, (y i - x i)‖ := by rw [← Finset.sum_sub_distrib]
        _ ≤ ∑ i, ‖y i - x i‖ := norm_sum_le _ _
        _ ≤ ∑ _i : Fin n, ε := sum_le_sum fun i _ => le_of_lt (hy_close i)
        _ = ↑n * ε := by simp [sum_const, nsmul_eq_mul]
    have h1 := p.le_opNorm ((∑ i, y i) - (∑ i, x i))
    rw [map_sub] at h1
    have h2 := le_abs_self (p (∑ i, y i) - p (∑ i, x i))
    rw [← Real.norm_eq_abs] at h2
    have h3 := mul_le_mul_of_nonneg_left sum_close (le_of_lt hC_pos)
    have bound : p (∑ i, y i) - p (∑ i, x i) ≤ ‖p‖ * (↑n * ε) := by linarith
    have small : ‖p‖ * (↑n * ε) < r - p (∑ i, x i) := by
      have hεd : ε * (‖p‖ * ↑n + 1) = r - p (∑ i, x i) := by
        show (r - p (∑ i, x i)) / (‖p‖ * ↑n + 1) * (‖p‖ * ↑n + 1) = r - p (∑ i, x i)
        field_simp
      have : ‖p‖ * (↑n * ε) = ε * (‖p‖ * ↑n + 1) - ε := by ring
      linarith
    linarith