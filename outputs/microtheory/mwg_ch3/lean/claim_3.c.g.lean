import Mathlib
open Topology

theorem leontief_not_differentiable :
    ¬ DifferentiableAt ℝ (fun p : ℝ × ℝ => min p.1 p.2) (1, 1) := by
  intro h
  apply not_differentiableAt_abs_zero
  have hg : DifferentiableAt ℝ (fun t : ℝ => ((1 : ℝ) + t, (1 : ℝ) - t)) (0 : ℝ) :=
    ((differentiableAt_const _).add differentiableAt_id).prodMk
      ((differentiableAt_const _).sub differentiableAt_id)
  have h' : DifferentiableAt ℝ (fun p : ℝ × ℝ => min p.1 p.2) ((1 : ℝ) + 0, (1 : ℝ) - 0) := by
    simp; exact h
  have h1 := h'.comp (0 : ℝ) hg
  have h2 : DifferentiableAt ℝ (fun t : ℝ => (1 : ℝ) - ((fun p : ℝ × ℝ => min p.1 p.2) ((1 + t, 1 - t))) ) 0 :=
    (differentiableAt_const _).sub h1
  exact h2.congr_of_eventuallyEq (Filter.Eventually.of_forall (fun t => by
    simp only [min_def]
    split_ifs with ht
    · rw [abs_of_nonpos (by linarith : t ≤ 0)]; ring
    · push_neg at ht; rw [abs_of_pos (by linarith : 0 < t)]; ring))