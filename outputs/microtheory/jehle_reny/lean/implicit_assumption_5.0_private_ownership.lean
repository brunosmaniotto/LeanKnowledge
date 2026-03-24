import Mathlib

open Finset BigOperators
open Topology

/-- The institution of private ownership: each consumer `i` is endowed with a
    commodity bundle `eⁱ ∈ ℝᴸ` over which they have exclusive rights. -/
structure PrivateOwnership (I L : Type*) [Fintype I] [Fintype L] where
  /-- Consumer i's endowment of commodity l -/
  endowment : I → L → ℝ
  /-- Endowments are nonnegative (one cannot own negative quantities) -/
  endowment_nonneg : ∀ i l, 0 ≤ endowment i l