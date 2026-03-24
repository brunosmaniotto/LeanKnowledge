import Mathlib

-- Let profits and the discount factor be real numbers.
variable {π_m π_d π_c δ : ℝ}

-- "The monopoly price is sustainable" means the present value of the payoff from
-- cooperating (getting monopoly profit π_m forever) is at least as large as the
-- payoff from deviating (getting a higher profit π_d once, then the competitive
-- profit π_c forever).
def MonopolyPriceSustainable (π_m π_d π_c δ : ℝ) : Prop :=
  π_m / (1 - δ) ≥ π_d + δ * π_c / (1 - δ)

-- "The present value of future losses from reversion is large enough relative to
-- the current gain from deviation" means the one-shot gain from deviating (π_d - π_m)
-- is no more than the discounted sum of future losses (getting π_c instead of π_m forever).