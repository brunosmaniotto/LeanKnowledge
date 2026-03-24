import Mathlib

open Classical
open Topology

-- Define the utility function for a single bidder in a second-price auction.
-- `v`: The bidder's true value for the item.
-- `b`: The bidder's own bid.
-- `o`: The highest bid among all other bidders.
-- The utility is `v - o` if the bidder wins (i.e., `b ≥ o`), otherwise it's `0`.
-- This definition is marked `noncomputable` because it depends on `Real.decidableLE`.
noncomputable def second_price_utility (v b o : ℝ) : ℝ :=
  if b ≥ o then v - o else 0

theorem Claim_III_C (v b o : ℝ) :
  second_price_utility v v o ≥ second_price_utility v b o := by
  -- Unfold the definition of `second_price_utility` for both sides of the inequality.
  dsimp [second_price_utility]
  -- The goal now involves `if` statements. `split_ifs` tactic handles these
  -- by performing case analysis on the conditions of the `if` statements.
  split_ifs with hv_ge_o hb_ge_o
  -- This generates four cases based on the truth values of `v ≥ o` and `b ≥ o`.
  -- Case 1: `v ≥ o` is true, and `b ≥ o` is true.
  . -- Goal: `v - o ≥ v - o`. This is trivially true.
    rfl
  -- Case 2: `v ≥ o` is true, and `b ≥ o` is false (i.e., `b < o`).
  . -- Goal: `v - o ≥ 0`.
    -- We have `hv_ge_o : v ≥ o`. From this, `v - o ≥ 0`.
    linarith [hv_ge_o]
  -- Case 3: `v ≥ o` is false (i.e., `v < o`), and `b ≥ o` is true.
  . -- Goal: `0 ≥ v - o`.
    -- We have `hv_ge_o : ¬(v ≥ o)`, which simplifies to `v < o`. This implies `o > v`, or `0 > v - o`.
    linarith [hv_ge_o]
  -- Case 4: `v ≥ o` is false (i.e., `v < o`), and `b ≥ o` is false (i.e., `b < o`).
  . -- Goal: `0 ≥ 0`. This is trivially true.
    rfl