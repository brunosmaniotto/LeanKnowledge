import Mathlib

theorem real_numbers_between_epsilons (a b : ℝ) (h : ∀ ε > 0, a - ε < b ∧ b < a + ε) : a = b := by
  have h1 : b ≤ a := by
    apply le_of_forall_pos_le_add
    intro ε hε
    have h' := h ε hε
    linarith [h'.right]
  have h2 : a ≤ b := by
    apply le_of_forall_pos_le_add
    intro ε hε
    have h' := h ε hε
    linarith [h'.left]
  exact le_antisymm h2 h1