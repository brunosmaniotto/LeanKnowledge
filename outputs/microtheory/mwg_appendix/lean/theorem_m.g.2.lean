import Mathlib
open Topology

theorem Theorem_M_G_2 {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]
    (B : Set E) (hB_convex : Convex ℝ B) (hB_closed : IsClosed B) (hB_ne : B.Nonempty)
    (x : E) (hx : x ∉ B) :
    ∃ (p : E), p ≠ 0 ∧ ∃ (c : ℝ), @inner ℝ E _ p x > c ∧ ∀ y ∈ B, @inner ℝ E _ p y ≤ c := by
  obtain ⟨y, hy_mem, hy_proj⟩ :=
    exists_norm_eq_iInf_of_complete_convex hB_ne hB_closed.isComplete hB_convex x
  have hxy : x ≠ y := fun h => hx (h ▸ hy_mem)
  have hsub_ne : x - y ≠ 0 := sub_ne_zero.mpr hxy
  have hvar : ∀ z ∈ B, @inner ℝ E _ (x - y) (z - y) ≤ 0 :=
    (norm_eq_iInf_iff_real_inner_le_zero hB_convex hy_mem).mp hy_proj
  refine ⟨x - y, hsub_ne, @inner ℝ E _ (x - y) y, ?_, ?_⟩
  · -- Need: inner (x-y) x > inner (x-y) y, i.e., inner (x-y) x - inner (x-y) y > 0
    have h1 : @inner ℝ E _ (x - y) x - @inner ℝ E _ (x - y) y = @inner ℝ E _ (x - y) (x - y) := by
      rw [← inner_sub_right]
    have h2 : @inner ℝ E _ (x - y) (x - y) = ‖x - y‖ ^ 2 := real_inner_self_eq_norm_sq _
    have h3 : (0 : ℝ) < ‖x - y‖ := norm_pos_iff.mpr hsub_ne
    linarith [sq_nonneg ‖x - y‖, sq_pos_of_pos h3]
  · intro z hz
    have h := hvar z hz
    have : @inner ℝ E _ (x - y) (z - y) = @inner ℝ E _ (x - y) z - @inner ℝ E _ (x - y) y := by
      rw [inner_sub_right]
    linarith