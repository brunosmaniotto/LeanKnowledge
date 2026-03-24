import Mathlib

open Finset BigOperators
open Topology

-- Financial market structure
structure FinancialMarket (K S : ℕ) where
  returns : Fin K → Fin S → ℝ  -- r_{sk} return of asset k in state s

-- Asset prices and multipliers
structure AssetPricing (K S : ℕ) where
  market : FinancialMarket K S
  prices : Fin K → ℝ  -- q_k price of asset k

-- Returns are nonneg and nonzero
def AllReturnsNonnegNonzero {K S : ℕ} (mkt : FinancialMarket K S) : Prop :=
  ∀ k : Fin K, (∀ s : Fin S, 0 ≤ mkt.returns k s) ∧
               (∃ s : Fin S, 0 < mkt.returns k s)

-- No-arbitrage condition