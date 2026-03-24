import Mathlib

open Finset
open Topology

noncomputable section

/-- In an English auction with IPV and dominant strategy play, the outcome is identical
    to the second-price auction: same winner (highest value) and same price (second-highest value). -/
theorem english_auction_equals_second_price
    {n : ℕ} (hn : 2 ≤ n)
    (v : Fin n → ℝ)
    (hv : Function.Injective v)
    -- The winner is the bidder with the highest value
    (winner : Fin n)
    (hwinner : ∀ j, v j ≤ v winner)
    -- English auction: each bidder drops at their value; winner is last standing,
    -- price = value at which the last competitor dropped = second-highest value
    (english_winner : Fin n)
    (english_price : ℝ)
    (h_eng_winner : english_winner = winner)
    (h_eng_price : ∀ j ≠ winner, v j ≤ english_price)
    (h_eng_price_eq : ∃ j ≠ winner, english_price = v j)
    (h_eng_price_max : ∀ j ≠ winner, v j ≤ english_price)
    (h_eng_is_second : ∀ p, (∀ j ≠ winner, v j ≤ p) → (∃ j ≠ winner, p = v j) → p = english_price)
    -- Second-price auction: highest bidder wins, pays second-highest bid;
    -- under dominant strategy (truthful bidding), bids = values
    (sp_winner : Fin n)
    (sp_price : ℝ)
    (h_sp_winner : sp_winner = winner)
    (h_sp_price : ∀ j ≠ winner, v j ≤ sp_price)
    (h_sp_price_eq : ∃ j ≠ winner, sp_price = v j)
    (h_sp_is_second : ∀ p, (∀ j ≠ winner, v j ≤ p) → (∃ j ≠ winner, p = v j) → p = sp_price)
    : english_winner = sp_winner ∧ english_price = sp_price := by
  constructor
  · rw [h_eng_winner, h_sp_winner]
  · -- Both prices are the second-highest value, so they are equal
    obtain ⟨j₁, hj₁ne, hj₁eq⟩ := h_eng_price_eq
    have h1 : english_price = sp_price := by
      have := h_sp_is_second english_price h_eng_price ⟨j₁, hj₁ne, hj₁eq⟩
      exact this
    exact h1