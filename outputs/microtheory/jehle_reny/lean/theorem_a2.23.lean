import Mathlib
open Topology

theorem Theorem_A2_23 {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]
    (C : Set E) (hC_convex : Convex ℝ C) (hC_closed : IsClosed C) (hC_ne : C.Nonempty)
    (h0 : (0 : E) ∉ C) :
    ∃ (p : E), ‖p‖ = 1 ∧ ∃ (α : ℝ), α > 0 ∧ ∀ c ∈ C, @inner ℝ E _ p c ≥ α := by
  obtain ⟨ĉ, hĉ_mem, hĉ_proj⟩ :=
    exists_norm_eq_iInf_of_complete_convex hC_ne hC_closed.isComplete hC_convex (0 : E)
  have hĉ_ne : ĉ ≠ 0 := fun h => h0 (h ▸ hĉ_mem)
  have hĉ_pos : (0 : ℝ) < ‖ĉ‖ := norm_pos_iff.mpr hĉ_ne
  have hvar : ∀ z ∈ C, @inner ℝ E _ ((0 : E) - ĉ) (z - ĉ) ≤ 0 :=
    (norm_eq_iInf_iff_real_inner_le_zero hC_convex hĉ_mem).mp hĉ_proj
  have hinner : ∀ z ∈ C, @inner ℝ E _ ĉ z ≥ ‖ĉ‖ ^ 2 := by
    intro z hz
    have h := hvar z hz
    have h1 : @inner ℝ E _ ((0 : E) - ĉ) (z - ĉ) =
        @inner ℝ E _ ĉ ĉ - @inner ℝ E _ ĉ z := by
      rw [zero_sub, inner_neg_left, inner_sub_right]; ring
    rw [h1] at h
    linarith [real_inner_self_eq_norm_sq ĉ]
  refine ⟨‖ĉ‖⁻¹ • ĉ, ?_, ‖ĉ‖, hĉ_pos, ?_⟩
  · rw [norm_smul, norm_inv, norm_norm, inv_mul_cancel₀ (ne_of_gt hĉ_pos)]
  · intro c hc
    rw [real_inner_smul_left]
    have h := hinner c hc
    have hinv : (0 : ℝ) ≤ ‖ĉ‖⁻¹ := le_of_lt (inv_pos.mpr hĉ_pos)
    have key : ‖ĉ‖⁻¹ * ‖ĉ‖ ^ 2 = ‖ĉ‖ := by
      rw [sq, ← mul_assoc, inv_mul_cancel₀ (ne_of_gt hĉ_pos), one_mul]
    linarith [mul_le_mul_of_nonneg_left h hinv]