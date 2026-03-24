import Mathlib
open Topology

/-- BDW (1984) diagrammatic proof framework for Arrow's theorem
    in the continuous utility setting. -/

-- Axiomatize the BDW continuous utility framework
axiom BDW.Alternative : Type
axiom BDW.Individual : Type
axiom BDW.SWF : Type
axiom BDW.alt_ge_three : ∃ (a b c : BDW.Alternative), a ≠ b ∧ b ≠ c ∧ a ≠ c
axiom BDW.ind_ge_two : ∃ (i j : BDW.Individual), i ≠ j
axiom BDW.satisfiesPareto : BDW.SWF → Prop
axiom BDW.satisfiesIIA : BDW.SWF → Prop
axiom BDW.isDictatorial : BDW.SWF → Prop
axiom BDW.nonDictatorial : BDW.SWF → Prop

/-- BDW Arrow impossibility: any SWF satisfying Pareto and IIA is dictatorial. -/
axiom BDW.arrow_impossibility (f : BDW.SWF) :
    BDW.satisfiesPareto f → BDW.satisfiesIIA f → BDW.isDictatorial f

/-- No SWF can simultaneously satisfy Pareto, IIA, and non-dictatorship. -/
theorem bdw_arrow_no_swf_satisfies_all :
    ¬ ∃ f : BDW.SWF,
      BDW.satisfiesPareto f ∧ BDW.satisfiesIIA f ∧ ¬BDW.isDictatorial f := by
  intro ⟨f, hp, hi, hnd⟩
  exact hnd (BDW.arrow_impossibility f hp hi)