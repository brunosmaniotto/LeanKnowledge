import Mathlib
open Topology

theorem Claim_22B_e : ∃ (S : Set ℝ), ¬ Convex ℝ S := by
  refine ⟨{(0 : ℝ), 1}, fun h => ?_⟩
  have h3 := h (by simp : (0 : ℝ) ∈ ({0, 1} : Set ℝ))
    (by simp : (1 : ℝ) ∈ ({0, 1} : Set ℝ))
    (by norm_num : (0 : ℝ) ≤ 1 / 2) (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (1 : ℝ) / 2 + 1 / 2 = 1)
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff, smul_eq_mul] at h3
  norm_num at h3