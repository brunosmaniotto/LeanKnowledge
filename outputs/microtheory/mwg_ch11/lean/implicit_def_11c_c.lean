import Mathlib

-- A type for consumers, which also indexes the personalized goods.
-- We assume a finite number of consumers as implied by "a bundle of I goods".
variable (I : Type) [Fintype I]

/-- A Lindahl equilibrium is a competitive equilibrium in personalized markets for the public good. -/
structure LindahlEquilibrium where
  -- `p i` is the personalized price for consumer `i` for the public good.
  p : I → ℝ
  -- `x i` is the consumption of the public good as experienced by consumer `i`.
  x : I → ℝ
  -- `φ i` is the utility function for consumer `i`, dependent on their consumption `x i`.
  φ : I → (ℝ → ℝ)

  -- Conditions that must hold for `p`, `x`, and `φ` to constitute a Lindahl equilibrium:

  -- 1. Non-negativity of consumption and prices.
  x_nonneg : ∀ i, 0 ≤ x i
  p_nonneg : ∀ i, 0 ≤ p i

  -- 2. Consumer Optimization: Each consumer `i` chooses `x i` to maximize their utility,
  -- subject to their personalized price `p i` and non-negativity of consumption.
  -- This means for any other feasible consumption `x'` (i.e., `x' ≥ 0`),
  -- the utility derived from `x i` (minus the cost) is greater than or equal to that from `x'`.
  consumer_maximization : ∀ i,
    ∀ x' : ℝ, 0 ≤ x' → φ i x' - p i * x' ≤ φ i (x i) - p i * (x i)

  -- 3. Production/Market Clearing (Fixed-Proportions Technology):
  -- The firm produces a bundle of `I` goods with fixed-proportions technology,
  -- meaning the production (and thus consumption) of each personalized good is the same.
  fixed_proportions_production : ∀ i j, x i = x j