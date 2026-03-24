import Mathlib
open Topology

theorem discontinuous_no_fixed_point :
    ∃ f : Set.Icc (0 : ℝ) 1 → Set.Icc (0 : ℝ) 1,
      ∀ x, f x ≠ x := by
  refine ⟨fun x =>
    if (x : ℝ) ≤ 1 / 2
    then ⟨1, by norm_num, by norm_num⟩
    else ⟨0, by norm_num, by norm_num⟩, ?_⟩
  intro ⟨x, hx⟩
  simp only [Set.mem_Icc] at hx
  dsimp only
  by_cases h : x ≤ 1 / 2
  · simp only [h, ite_true]
    intro heq
    have := congr_arg Subtype.val heq
    simp at this
    linarith
  · push_neg at h
    simp only [show ¬(x ≤ 1 / 2) from by linarith, ite_false]
    intro heq
    have := congr_arg Subtype.val heq
    simp at this
    linarith