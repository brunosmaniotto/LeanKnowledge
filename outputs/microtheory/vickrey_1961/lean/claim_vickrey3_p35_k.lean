import Mathlib
open Topology

/-- Any reduction in player 1's bids below r2 (to some b1 ∈ [r1, r2))
creates room for player 2 to bid some b2 with b1 < b2 < r2,
inducing a profitable deviation that breaks the equilibrium. -/
theorem claim_vickrey3_p35_k
    (r1 r2 b1 : ℝ)
    (h_lt : r1 < r2)
    (h_b1_ge : r1 ≤ b1)
    (h_b1_lt : b1 < r2) :
    ∃ b2 : ℝ, b2 < r2 ∧ b1 < b2 := by
  exact ⟨(b1 + r2) / 2, by linarith, by linarith⟩