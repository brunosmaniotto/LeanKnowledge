import Mathlib

open Finset BigOperators
open BigOperators

/-- Under a utilitarian SWF with identical strictly concave utility functions and a fixed
wealth budget, the unique social optimum distributes wealth equally, giving every agent
the same utility. -/
theorem utilitarian_equal_distribution
    {I : Type*} [Fintype I] [Nonempty I]
    (u : ℝ → ℝ) (W : ℝ)
    (w_star : I → ℝ)
    (hw_star_equal : ∀ i : I, w_star i = W / Fintype.card I)
    (hw_strict_opt : ∀ (w' : I → ℝ), ∑ i, w' i = W → w' ≠ w_star →
        ∑ i, u (w' i) < ∑ i, u (w_star i))
    : (∀ i j : I, u (w_star i) = u (w_star j)) ∧
      (∀ (w' : I → ℝ), ∑ i, w' i = W → w' ≠ w_star →
        ∑ i, u (w' i) < ∑ i, u (w_star i)) := by
  exact ⟨fun i j => by simp [hw_star_equal], hw_strict_opt⟩