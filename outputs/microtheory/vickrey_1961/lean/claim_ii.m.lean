import Mathlib

-- The function defining the bid according to the given relation.
-- We mark it noncomputable because it involves real number division,
-- which in Lean is often noncomputable.
-- If N_bidders is 0, the bid is defined as 0 to avoid division by zero.
noncomputable def dutchAuctionBid (N_bidders : ℕ) (player_value : ℝ) : ℝ :=
  if N_bidders > 0 then ((N_bidders : ℝ) - 1) / (N_bidders : ℝ) * player_value
  else 0

theorem Claim_II.M (N : ℕ) (v : ℝ) (hN : N > 0) :
  dutchAuctionBid N v = (((N : ℝ) - 1) / (N : ℝ)) * v := by
  -- The `simp` tactic, given the definition of `dutchAuctionBid` and the
  -- hypothesis `hN : N > 0`, will unfold `dutchAuctionBid` and resolve
  -- the `if` conditional. This makes both sides of the equality
  -- definitionally identical, allowing `simp` to close the goal.
  simp [dutchAuctionBid, if_pos hN]