import Mathlib

open Classical
open Topology

/-- Payoff in an English auction: if dropout price `b` exceeds the winning price `p`,
    the bidder wins and gets `v - p`; otherwise gets 0. -/
noncomputable def english_auction_payoff (v b p : ℝ) : ℝ :=
  if b > p then v - p else 0

/-- Theorem 9.4: Truthful bidding (dropping out at one's value) is the unique
    weakly dominant strategy in an English auction with independent private values. -/
theorem Theorem_9_4 (v b : ℝ) (hne : b ≠ v) :
    (∀ p : ℝ, english_auction_payoff v v p ≥ english_auction_payoff v b p) ∧
    (∃ p : ℝ, english_auction_payoff v v p > english_auction_payoff v b p) := by
  constructor
  · intro p
    simp only [english_auction_payoff]
    split_ifs <;> linarith
  · obtain hlt | hgt := lt_or_gt_of_ne hne
    · exact ⟨b, by simp only [english_auction_payoff]; split_ifs <;> linarith⟩
    · exact ⟨(v + b) / 2, by simp only [english_auction_payoff]; split_ifs <;> linarith⟩