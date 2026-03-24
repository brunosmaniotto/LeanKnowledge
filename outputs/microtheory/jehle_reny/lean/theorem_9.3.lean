import Mathlib

open Classical
open Topology

/-- Payoff in a second-price sealed-bid auction: winner pays the second-highest bid. -/
noncomputable def spa_payoff (value bid highest_other : ℝ) : ℝ :=
  if bid > highest_other then value - highest_other else 0

/-- Theorem 9.3 (Vickrey): Bidding one's true value is the unique weakly
    dominant strategy in a second-price sealed-bid auction.
    Part 1: truthful bidding weakly dominates any alternative bid.
    Part 2: any bid b ≠ v is strictly worse for some realization of others' bids. -/
theorem Theorem_9_3 (v b : ℝ) :
    (∀ B : ℝ, spa_payoff v v B ≥ spa_payoff v b B) ∧
    (b ≠ v → ∃ B : ℝ, spa_payoff v v B > spa_payoff v b B) := by
  constructor
  · -- Weak dominance: bidding v is always at least as good as bidding b
    intro B
    unfold spa_payoff
    split_ifs <;> linarith
  · -- Uniqueness: any non-truthful bid does strictly worse for B = (v+b)/2
    intro hne
    refine ⟨(v + b) / 2, ?_⟩
    unfold spa_payoff
    rcases lt_or_gt_of_ne hne with h | h <;> (split_ifs <;> linarith)