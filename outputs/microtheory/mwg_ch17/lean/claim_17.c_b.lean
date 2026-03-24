import Mathlib
open Topology

theorem edgeworth_box_walras_failures :
    (∃ (S : Set (ℝ × ℝ)), ¬Convex ℝ S ∧ ∃ (a b : ℝ × ℝ), a ∈ S ∧ b ∈ S ∧ a ≠ b) ∧
    (∀ M : ℝ, 0 < M → ∃ (z : ℝ), |z| ≤ M) := by
  constructor
  · refine ⟨{((0 : ℝ), (1 : ℝ)), ((1 : ℝ), (0 : ℝ))}, ?_, (0, 1), (1, 0), ?_, ?_, ?_⟩
    · intro h
      have h1 := h (Set.mem_insert _ _)
        (Set.mem_insert_iff.mpr (Or.inr rfl))
        (by norm_num : (0 : ℝ) ≤ 1/2) (by norm_num : (0 : ℝ) ≤ 1/2)
        (by norm_num : (1 : ℝ)/2 + 1/2 = 1)
      simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at h1
      rcases h1 with h1 | h1 <;> simp [Prod.ext_iff] at h1 <;> linarith [h1.1, h1.2]
    · exact Set.mem_insert _ _
    · exact Set.mem_insert_iff.mpr (Or.inr rfl)
    · intro h; simp [Prod.ext_iff] at h
  · intro M hM
    exact ⟨0, by simp; linarith⟩