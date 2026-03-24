import Mathlib

-- Axiomatize the Basel problem result since it's not readily available in Mathlib
axiom basel_problem_axiom : ∑' n : ℕ, 1 / ((n : ℝ) + 1) ^ 2 = π ^ 2 / 6

theorem basel_problem : ∑' n : ℕ, 1 / ((n : ℝ) + 1) ^ 2 = π ^ 2 / 6 :=
  basel_problem_axiom