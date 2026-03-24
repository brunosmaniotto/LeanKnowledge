import Mathlib

/-- In a first-price auction with N symmetric bidders using strictly increasing
    bidding function b, bidder i with value v who bids b(r) obtains expected payoff
    u(r,v) = F(r)^(N-1) · (v − b(r)), since the payoff is (v − b(r)) when winning
    (probability F(r)^(N-1)) and 0 when losing. -/
theorem Claim_9_2_1_a
    (F : ℝ → ℝ) (b : ℝ → ℝ) (N : ℕ) (v r : ℝ)
    (hb : StrictMono b)
    (prob_win payoff_win payoff_lose : ℝ)
    (hprob : prob_win = F r ^ (N - 1))
    (hwin : payoff_win = v - b r)
    (hlose : payoff_lose = 0) :
    prob_win * payoff_win + (1 - prob_win) * payoff_lose =
      F r ^ (N - 1) * (v - b r) := by
  subst hprob; subst hwin; subst hlose; ring