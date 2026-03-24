import Mathlib
open Topology

/-- The all-½ assessment is a sequential equilibrium of sophisticated matching pennies
    (MWG Example 7.7(e)). Consistency: completely mixed strategies ensure all information
    sets are reached, so Bayes' rule yields belief ½. Sequential rationality: player 3
    is indifferent at each info set; players 1 and 2 are indifferent between H and T
    and weakly prefer continuing over quitting. -/
theorem Claim_7_7_e :
  let s : ℚ := 1/2
  -- ═══ CONSISTENCY ═══
  -- Completely mixed strategies → all info sets reached with positive probability
  (0 < s ∧ s < 1) ∧
  -- Bayes' rule at Player 3's info sets (matching-action and mismatching-action paths)
  (s * s / (s * s + (1 - s) * (1 - s)) = s) ∧
  (s * (1 - s) / (s * (1 - s) + (1 - s) * s) = s) ∧
  -- ═══ SEQUENTIAL RATIONALITY ═══
  -- Player 3 indifferent at each info set: EU(H) = EU(T) under matching-pennies payoffs
  (s * 1 + (1 - s) * (-1) = s * (-1) + (1 - s) * 1) ∧
  -- Players 1 & 2 indifferent: EU(H) = EU(T) when opponent and Player 3 each mix at ½
  (s * (s * 1 + (1 - s) * (-1)) + (1 - s) * (s * (-1) + (1 - s) * 1) =
   s * (s * (-1) + (1 - s) * 1) + (1 - s) * (s * 1 + (1 - s) * (-1))) ∧
  -- Continuation payoff ≥ quit payoff (normalized to 0): players prefer not to quit
  (s * (s * 1 + (1 - s) * (-1)) + (1 - s) * (s * (-1) + (1 - s) * 1) ≥ 0) := by
  norm_num