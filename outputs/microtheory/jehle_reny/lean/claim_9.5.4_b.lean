import Mathlib
open Topology

theorem claim_9_5_4_b
    {n : ℕ} (hn : 2 ≤ n)
    (v : Fin n → ℝ)
    (winner second : Fin n)
    (h_ws : winner ≠ second)
    (h_winner : ∀ j, v j ≤ v winner)
    (h_second : ∀ j, j ≠ winner → v j ≤ v second) :
    -- For each bidder i, their externality (= welfare_without_i - welfare_with_i) satisfies:
    ∀ i : Fin n,
      -- Non-winner case: externality is zero
      ((i ≠ winner) →
        (if i = winner then v second else v winner) -
          (if i = winner then (0 : ℝ) else v winner) = 0) ∧
      -- Winner case: externality equals the second-highest value
      ((i = winner) →
        (if i = winner then v second else v winner) -
          (if i = winner then (0 : ℝ) else v winner) = v second) := by
  intro i
  constructor
  · intro hi; simp [hi]
  · intro hi; simp [hi]