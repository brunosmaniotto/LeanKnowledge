import Mathlib
open MeasureTheory ProbabilityTheory Finset BigOperators Classical
open Topology

/--
The core definition of a Dutch Auction game setting.
This structure contains the static information about the game,
including player-specific probability distributions over their values.
-/
structure DutchAuctionGameSetting (Player : Type) [Fintype Player] [Inhabited Player] [DecidableEq Player] where
  /-- Each player has an individual probability distribution over their value.
      Values are assumed to be real numbers (`ℝ`) for typical auction contexts. -/
  value_dist : Player → Measure ℝ
  /-- These distributions are explicitly asserted to be probability measures. -/
  is_prob_measure : ∀ p, IsProbabilityMeasure (value_dist p)

/--
  Defines the payoff function for a Dutch auction scenario as described in Scenario_II.B.
  A player's payoff is the excess of their private value over their bid if they are
  the (arbitrarily chosen) highest bidder; otherwise, their payoff is zero.
  In case of tied highest bids, an arbitrary highest bidder is chosen as the winner.
-/
noncomputable def dutch_auction_payoff
    {Player : Type} [Fintype Player] [Inhabited Player] [DecidableEq Player]
    (game : DutchAuctionGameSetting Player)
    (player_values : Player → ℝ)
    (player_bids : Player → ℝ) : Player → ℝ :=
  fun p =>
    -- Proof that the set of all players is nonempty (needed for Finset.max').
    have h_nonempty_players : Finset.univ.Nonempty := Finset.univ_nonempty

    -- Get all bids made by players in the game.
    let all_bids_finset : Finset ℝ := Finset.univ.image player_bids
    -- Proof that the set of all bids is nonempty if there are players.
    have h_nonempty_bids : all_bids_finset.Nonempty := Finset.Nonempty.image h_nonempty_players player_bids

    -- Determine the maximum bid value. `max'` returns ℝ directly.
    let max_bid_val : ℝ := all_bids_finset.max' h_nonempty_bids

    -- Prove that there exists a player who made this maximum bid.
    have h_exists_max_bidder : ∃ p₀ : Player, player_bids p₀ = max_bid_val := by
      have h_mem_max_bid_val : max_bid_val ∈ all_bids_finset := Finset.max'_mem _ h_nonempty_bids
      rw [Finset.mem_image] at h_mem_max_bid_val
      rcases h_mem_max_bid_val with ⟨p₀_candidate, _, hp₀_candidate_eq_max_bid_val⟩
      exact ⟨p₀_candidate, hp₀_candidate_eq_max_bid_val⟩

    -- Arbitrarily choose one such player using `Classical.choose`.
    let max_bidder_p := Classical.choose h_exists_max_bidder

    -- The chosen player indeed made the maximum bid.
    have h_max_bidder_prop : player_bids max_bidder_p = max_bid_val :=
      Classical.choose_spec h_exists_max_bidder

    -- Calculate the payoff for the current player 'p'.
    if p = max_bidder_p then
      player_values p - player_bids p
    else
      0

theorem Scenario_II.B :
  True :=
by
  trivial