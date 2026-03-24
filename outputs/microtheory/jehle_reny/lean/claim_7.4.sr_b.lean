import Mathlib
open Topology

/-- In the game of Fig. 7.27, the SPE where player 1 plays L and player 2 plays m
    is not sequentially rational: no beliefs p make m a best response at player 2's
    information set, because m is strictly dominated at every node. -/
theorem claim_7_4_SR_b
    {m₀ m₁ a₀ a₁ : ℝ}
    (h0 : m₀ < a₀) (h1 : m₁ < a₁) :
    ¬ ∃ p : ℝ, 0 ≤ p ∧ p ≤ 1 ∧
      p * a₀ + (1 - p) * a₁ ≤ p * m₀ + (1 - p) * m₁ := by
  push_neg
  intro p hp0 hp1
  rcases hp0.lt_or_eq with hp | rfl
  · linarith [mul_lt_mul_of_pos_left h0 hp,
              mul_le_mul_of_nonneg_left (le_of_lt h1) (show (0 : ℝ) ≤ 1 - p by linarith)]
  · simp; linarith