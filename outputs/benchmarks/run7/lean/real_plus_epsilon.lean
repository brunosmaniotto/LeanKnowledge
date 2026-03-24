import Mathlib

theorem real_plus_epsilon (a b : ℝ) (h : ∀ ε > 0, a < b + ε) : a ≤ b := by
  by_contra h_notle
  have h_lt : b < a := lt_of_not_ge h_notle
  have h_pos : 0 < a - b := sub_pos_of_lt h_lt
  have h_ineq := h (a - b) h_pos
  linarith