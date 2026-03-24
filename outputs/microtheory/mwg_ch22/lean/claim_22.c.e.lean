import Mathlib
open Topology

theorem non_convex_UPS_local_not_global :
    ∃ (S : Set ℝ) (w : ℝ → ℝ),
      ¬Convex ℝ S ∧
      ConcaveOn ℝ Set.univ w ∧
      (∃ x_local ∈ S, ∃ x_global ∈ S,
        w x_global > w x_local ∧
        (∀ y ∈ S, |y - x_local| < 1 → w y ≤ w x_local)) := by
  refine ⟨{0, 2}, id, ?_, ?_, ?_⟩
  · -- {0, 2} is not convex
    intro h
    have h1 := h (Set.mem_insert 0 {2}) (Set.mem_insert_iff.mpr (Or.inr rfl))
      (show (0 : ℝ) ≤ 1/2 by norm_num) (show (0 : ℝ) ≤ 1/2 by norm_num)
      (show (1 : ℝ)/2 + 1/2 = 1 by norm_num)
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at h1
    rcases h1 with h1 | h1 <;> norm_num at h1
  · exact concaveOn_id convex_univ
  · exact ⟨0, Set.mem_insert 0 {2}, 2, Set.mem_insert_iff.mpr (Or.inr rfl), by norm_num,
      fun y hy hdist => by
        simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
        rcases hy with rfl | rfl
        · exact le_refl _
        · exfalso
          simp only [sub_zero, abs_of_pos (by norm_num : (2:ℝ) > 0)] at hdist
          linarith⟩