import Mathlib
open Topology
open BigOperators

/-- A coalitional game in characteristic form with transferable utility. -/
structure CoalitionalGame (I : Type*) [Fintype I] where
  /-- The worth function assigning a value to each coalition. -/
  v : Finset I → ℝ

namespace CoalitionalGame

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- The utility possibility set for coalition S: all utility vectors u ∈ ℝˢ
    such that the sum of utilities does not exceed the coalition's worth. -/
noncomputable def utilityPossibilitySet (G : CoalitionalGame I) (S : Finset I) :
    Set (I → ℝ) :=
  {u | ∑ i ∈ S, u i ≤ G.v S}

end CoalitionalGame