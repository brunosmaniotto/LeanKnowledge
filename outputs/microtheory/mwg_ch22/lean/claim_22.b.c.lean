import Mathlib
open Topology

theorem claim_22B_c :
    ∃ (f : ℝ → ℝ) (x₀ : ℝ),
      HasDerivAt f 0 x₀ ∧ ¬∀ x, f x ≤ f x₀ := by
  refine ⟨fun x => x ^ 3, 0, ?_, ?_⟩
  · -- HasDerivAt (fun x => x ^ 3) 0 0
    have h := hasDerivAt_pow 3 (0 : ℝ)
    simp at h
    exact h
  · -- ¬ ∀ x, x ^ 3 ≤ 0 ^ 3
    push_neg
    exact ⟨1, by norm_num⟩