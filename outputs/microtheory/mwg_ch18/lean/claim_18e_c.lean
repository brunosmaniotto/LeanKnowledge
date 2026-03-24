import Mathlib
open Topology
open BigOperators

-- Envelope theorem for welfare maximization (18.E.2)
-- At Walrasian allocations, each consumer's marginal contribution to social utility
-- equals her direct utility (the net trade term p·(ω_h - x*_h) vanishes).

variable {L : ℕ} -- number of commodities

structure WelfareAllocation (L : ℕ) where
  H : Type*  -- consumer types
  [fin_H : Fintype H]
  u : H → ℝ  -- utility at optimal allocation x*_h
  p : Fin L → ℝ  -- Lagrange multiplier (price) vector
  omega : H → Fin L → ℝ  -- endowments
  x_star : H → Fin L → ℝ  -- optimal consumption
  marginal_value : H → ℝ  -- ∂v(μ̄)/∂μ_h
  envelope : ∀ h, marginal_value h = u h + ∑ l, p l * (omega h l - x_star h l)
  walrasian : ∀ h, ∑ l, p l * (omega h l - x_star h l) = 0

theorem envelope_theorem_walrasian_characterization
    {L : ℕ} (W : WelfareAllocation L) [Fintype W.H]
    (h : W.H) :
    W.marginal_value h = W.u h := by
  rw [W.envelope h, W.walrasian h, add_zero]