import Mathlib
open Topology

/-- An English (ascending-price) auction for a single indivisible object.

The seller raises the price continuously from zero. Each bidder drops out at
some price; once out, re-entry is forbidden. The last remaining bidder wins
and pays the price at which the penultimate bidder dropped out. -/
structure EnglishAuction (n : ℕ) (hn : 2 ≤ n) where
  /-- Drop-out price for each bidder (the price at which bidder i exits). -/
  dropOut : Fin n → ℝ
  /-- Drop-out prices are nonneg (price starts at zero and increases). -/
  dropOut_nonneg : ∀ i, 0 ≤ dropOut i
  /-- The winner is the bidder with the highest drop-out price (last one remaining). -/
  winner : Fin n
  /-- The winner has the highest drop-out price. -/
  winner_spec : ∀ i, dropOut i ≤ dropOut winner
  /-- The price paid by the winner (second-highest drop-out price). -/
  payment : ℝ
  /-- Payment is nonneg. -/
  payment_nonneg : 0 ≤ payment
  /-- The payment is realized by some runner-up and is the max among non-winners. -/
  payment_spec : ∃ j, j ≠ winner ∧ dropOut j = payment ∧ ∀ i, i ≠ winner → dropOut i ≤ payment