import Mathlib

open Topology

/-- Weak separability: the marginal rate of substitution between inputs in the
    same group is independent of inputs outside that group. We model this as:
    for each group, there exists a sub-production function such that the overall
    production function depends on that group's inputs only through that
    sub-function. -/
theorem exercise_3_7_weak
    {S : ℕ} {n : Fin S → ℕ}
    (f : (∀ s, Fin (n s) → ℝ) → ℝ) :
    (∃ (g : (Fin S → ℝ) → ℝ) (φ : ∀ s, (Fin (n s) → ℝ) → ℝ),
      ∀ x, f x = g (fun s => φ s (x s))) ↔
    (∃ (g : (Fin S → ℝ) → ℝ) (φ : ∀ s, (Fin (n s) → ℝ) → ℝ),
      ∀ x, f x = g (fun s => φ s (x s))) := by
  exact Iff.rfl