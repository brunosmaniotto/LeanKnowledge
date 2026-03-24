import Mathlib

-- Expected payoff for player 1 in the game of Fig. 7.27 when player 1 plays L with probability p
-- and player 2 plays m with probability q. (The payoff for player 1 is (1-p)*(q+1).)
noncomputable def E1 (p q : ℝ) : ℝ := (1 - p) * (q + 1)

-- Definition of best response for player 1: p is a best response to q if for all p' in [0,1],
-- E1(p, q) ≥ E1(p', q).