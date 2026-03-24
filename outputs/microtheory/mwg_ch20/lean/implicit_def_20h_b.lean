import Mathlib

open BigOperators Finset
open Topology

/-- Budget constraints for an OLG economy with a durable asset.
    Each generation t lives two periods: born (b) and adult (a).
    - `p` is the price sequence
    - `c_b t` is consumption when born in period t
    - `c_a t` is consumption when adult (period t+1) for generation t
    - `ε` is the asset's dividend share of endowment
    - `M` is the bubble component (asset price above fundamental value)
-/
structure OLGBudgetConstraint (p : ℕ → ℝ) (c_b c_a : ℕ → ℝ) (ε : ℝ) (M : ℝ) : Prop where
  /-- Budget constraint for generation t > 0 -/
  later_gen : ∀ t : ℕ, 0 < t →
    p t * c_b t + p (t + 1) * c_a t ≤ (1 - ε) * p t
  /-- Budget constraint for generation 0, includes asset fundamental value and bubble -/
  gen_zero :
    p 0 * c_b 0 + p 1 * c_a 0 ≤ (1 - ε) * p 0 + ε * (∑' t, p t) + M
  /-- The bubble component is nonnegative -/
  bubble_nonneg : 0 ≤ M