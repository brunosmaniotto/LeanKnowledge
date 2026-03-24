import Mathlib
open Topology

/-- In an English auction with independent private values, it is a dominant strategy
    for bidder i with value v_i to remain active until price v_i.
    At price p < v_i, dropping out yields payoff 0, while staying yields:
    • v_i - final_price ≥ 0 if the bidder wins (final_price ≤ v_i), or
    • 0 if someone else stays above v_i.
    Hence staying weakly dominates dropping out early. -/
theorem Claim_9_2_4_a (v_i p final_price : ℝ) (hp : p < v_i)
    (wins : Prop) [Decidable wins]
    (h_win : wins → final_price ≤ v_i) :
    (if wins then v_i - final_price else 0) ≥ (0 : ℝ) := by
  split_ifs with h
  · linarith [h_win h]
  · linarith