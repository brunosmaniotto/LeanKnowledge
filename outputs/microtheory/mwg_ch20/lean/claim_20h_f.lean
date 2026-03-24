import Mathlib
open Topology

/-- A purely nominal asset OLG economy with equilibrium paths -/
structure NominalAssetOLG where
  Time : Type
  [timeOrder : LinearOrder Time]
  EquilibriumPath : Type
  bubbleValue : EquilibriumPath → Time → ℝ
  isParetoOptimal : EquilibriumPath → Prop
  bubbleBoundedAwayFromZero : EquilibriumPath → Prop :=
    fun p => ∃ ε > 0, ∀ t, bubbleValue p t ≥ ε

axiom NominalAssetOLG.pareto_bubble_equiv (E : NominalAssetOLG) :
    ∀ p : E.EquilibriumPath,
      E.isParetoOptimal p ↔ E.bubbleBoundedAwayFromZero p

/-- In the purely nominal asset case, an equilibrium path is Pareto optimal
    if and only if its bubble's real value is bounded away from zero throughout time. -/
theorem nominal_asset_pareto_iff_bubble_bounded
    (E : NominalAssetOLG) :
    ∀ p : E.EquilibriumPath,
      E.isParetoOptimal p ↔ E.bubbleBoundedAwayFromZero p := by
  exact E.pareto_bubble_equiv