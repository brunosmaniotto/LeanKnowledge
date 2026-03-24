import Mathlib

-- We model prices and quantities using real numbers.
variable {S D : ℝ → ℝ} {p_market p_fixed : ℝ}

-- Assume supply is strictly increasing and demand is strictly decreasing for non-negative prices.
variable (hS_mono : StrictMonoOn S (Set.Ici 0))
variable (hD_mono : StrictAntiOn D (Set.Ici 0))
variable (h_p_market_nonneg : 0 ≤ p_market)
variable (h_p_fixed_nonneg : 0 ≤ p_fixed)

-- The equilibrium price is where supply equals demand.
variable (h_equilibrium : D p_market = S p_market)

/-- The quantity of goods traded in a market with a fixed price `p`.
This is determined by the "short side" of the market, i.e., the minimum of supply and demand. -/
def TradedQuantity (p : ℝ) : ℝ := min (D p) (S p)