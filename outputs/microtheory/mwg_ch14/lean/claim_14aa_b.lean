import Mathlib
open Set
open Topology

theorem Claim_14AA_b :
    ¬ (∀ (f w : ℝ → ℝ), (∀ e, f e ≥ 0) → (∀ e, w e ≥ 0) →
      ConcaveOn ℝ Set.univ (fun e => f e * w e)) := by
  push_neg
  refine ⟨fun e => e ^ 2, fun _ => 1, fun e => by positivity, fun _ => by norm_num, ?_⟩
  simp only [mul_one]
  intro h
  have h1 := h.2 (mem_univ (0 : ℝ)) (mem_univ (2 : ℝ))
    (by norm_num : (0 : ℝ) ≤ 1/2) (by norm_num : (0 : ℝ) ≤ 1/2)
    (by norm_num : (1 : ℝ)/2 + 1/2 = 1)
  simp at h1
  nlinarith [sq_nonneg (1 : ℝ)]