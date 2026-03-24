import Mathlib

theorem real_add_closed : ∀ (x y : ℝ), x + y ∈ (Set.univ : Set ℝ) := by
  intro x y
  simp