import Mathlib
open Topology

theorem exercise_4_4 : ∃ (d₁ d₂ : ℝ → ℝ),
    Monotone d₁ ∧ ¬Monotone (fun p => d₁ p + d₂ p) := by
  refine ⟨fun p => p, fun p => -3 * p, fun _ _ h => h, ?_⟩
  intro h
  have h1 := h (show (0 : ℝ) ≤ 1 by norm_num)
  norm_num at h1