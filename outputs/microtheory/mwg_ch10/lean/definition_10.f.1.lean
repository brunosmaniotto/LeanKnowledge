import Mathlib

-- Definition_10.F.1
structure LongRunCompetitiveEquilibrium (x c : Real → Real) where
  p_star : Real
  q_star : Real
  J_star : Real
  p_star_nonneg : 0 ≤ p_star
  q_star_nonneg : 0 ≤ q_star
  J_star_nonneg : 0 ≤ J_star
  profit_maximization :
    -- q* solves Max_{q≥0} p*q − c(q).
    -- This means that for any non-negative quantity q_prime,
    -- the profit at q* must be greater than or equal to the profit at q_prime.
    ∀ q_prime : Real, 0 ≤ q_prime → p_star * q_star - c q_star ≥ p_star * q_prime - c q_prime
  demand_supply_equality : x p_star = J_star * q_star
  free_entry_condition : p_star * q_star - c q_star = 0