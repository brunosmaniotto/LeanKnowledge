import Mathlib

/-- Revenue equivalence of the four standard auctions (Claim 9.3.1_b).
    Auctions: 0=English, 1=Dutch, 2=First-price sealed-bid, 3=Second-price sealed-bid.
    By Theorem 9.6, same probability assignment + zero utility at zero value ⟹ same revenue. -/
theorem claim_9_3_1_b
    (revenue : Fin 4 → ℝ)
    (prob_assignment : Fin 4 → ℝ → ℝ)
    (zero_value_utility : Fin 4 → ℝ)
    -- Condition (1): all four auctions assign the object to the highest-value bidder
    (h_same_prob : ∀ i j : Fin 4, prob_assignment i = prob_assignment j)
    -- Condition (2): a bidder with value zero receives expected utility zero
    (h_zero_util : ∀ i : Fin 4, zero_value_utility i = 0)
    -- Theorem 9.6 (Revenue Equivalence): same assignment + same boundary condition → same revenue
    (h_thm_9_6 : ∀ i j : Fin 4,
      prob_assignment i = prob_assignment j →
      zero_value_utility i = 0 →
      zero_value_utility j = 0 →
      revenue i = revenue j) :
    ∀ i j : Fin 4, revenue i = revenue j := by
  intro i j
  exact h_thm_9_6 i j (h_same_prob i j) (h_zero_util i) (h_zero_util j)