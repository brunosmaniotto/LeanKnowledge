import Mathlib

open Classical

-- Define the gain for bidder 1.
-- If bidder 1 wins (b₁ > b₂), they pay b₂ and their gain is v₁ - b₂.
-- If bidder 1 loses (b₁ ≤ b₂), their gain is 0.
-- The overall gain cannot be negative from the perspective of the problem, hence `max 0 ...`.
-- This definition is `noncomputable` because it uses `if-then-else` on `ℝ` propositions,
-- which depend on `Real.decidableLT`, a noncomputable instance.
noncomputable def BidderOneGain (v₁ b₁ b₂ : ℝ) : ℝ :=
  if b₁ > b₂ then max 0 (v₁ - b₂) else 0

theorem Claim_II.AA (v₁ b₁ b₂ a : ℝ)
    (hv₁ : v₁ < a / 2) (hb₂ : a / 2 ≤ b₂) :
    BidderOneGain v₁ b₁ b₂ ≤ 0 := by
  -- Unfold the definition of BidderOneGain to reveal the if-then-else structure.
  unfold BidderOneGain
  -- Use `by_cases` on the condition `b₁ > b₂` to split the proof into two cases.
  by_cases h_b1_gt_b2 : b₁ > b₂
  . -- Case 1: b₁ > b₂ is true (bidder 1 wins).
    -- The goal becomes `(if True then max 0 (v₁ - b₂) else 0) ≤ 0`, which simplifies to `max 0 (v₁ - b₂) ≤ 0`.
    simp only [h_b1_gt_b2, ite_true]
    -- We need to prove `max 0 (v₁ - b₂) ≤ 0`.
    -- This is equivalent to `0 ≤ 0` and `v₁ - b₂ ≤ 0`.
    apply max_le_iff.mpr
    constructor
    . -- Prove 0 ≤ 0.
      apply le_rfl
    . -- Prove v₁ - b₂ ≤ 0.
      -- From hv₁: v₁ < a / 2
      -- From hb₂: a / 2 ≤ b₂
      -- By transitivity, v₁ < b₂.
      -- This implies v₁ - b₂ < 0, and thus v₁ - b₂ ≤ 0.
      linarith [hv₁, hb₂]
  . -- Case 2: b₁ > b₂ is false, i.e., b₁ ≤ b₂ (bidder 1 does not win).
    -- The goal becomes `(if False then max 0 (v₁ - b₂) else 0) ≤ 0`, which simplifies to `0 ≤ 0`.
    simp only [h_b1_gt_b2, ite_false]
    -- Prove 0 ≤ 0.
    apply le_rfl