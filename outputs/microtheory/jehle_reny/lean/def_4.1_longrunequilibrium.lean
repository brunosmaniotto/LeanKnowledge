import Mathlib

open BigOperators Finset

/-- Long-run equilibrium in a competitive market.
    Given demand `qd`, supply functions `q_j`, and profit functions `π_j`,
    a long-run equilibrium consists of a price `p̂` and number of firms `Ĵ`
    satisfying market clearing and zero profit conditions. -/
structure LongRunEquilibrium
    (qd : ℝ → ℝ)
    (qs : ℕ → ℝ → ℝ)
    (profit : ℕ → ℝ → ℝ) where
  p_hat : ℝ
  J_hat : ℕ
  J_hat_pos : 0 < J_hat
  market_clearing : qd p_hat = ∑ j ∈ range J_hat, qs (j + 1) p_hat
  zero_profit : ∀ j, j ∈ range J_hat → profit (j + 1) p_hat = 0