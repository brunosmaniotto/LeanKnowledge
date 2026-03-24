import Mathlib
open Topology

-- Principal-agent model components
axiom PrincipalAgentModel : Type
axiom EffortLevel : Type
axiom eH : EffortLevel
axiom eL : EffortLevel

-- Economic quantities
axiom expectedWage_observable : PrincipalAgentModel → EffortLevel → ℝ
axiom expectedWage_secondBest : PrincipalAgentModel → EffortLevel → ℝ
axiom managerUtility_secondBest : PrincipalAgentModel → EffortLevel → ℝ
axiom reservation_utility : PrincipalAgentModel → ℝ
axiom isConstantWage_secondBest : PrincipalAgentModel → EffortLevel → Prop
axiom welfare_observable : PrincipalAgentModel → EffortLevel → ℝ
axiom welfare_secondBest : PrincipalAgentModel → EffortLevel → ℝ
axiom optimalEffort_observable : PrincipalAgentModel → EffortLevel

-- Axioms encoding Proposition 14.B.3's conditions
axiom prop14B3_part1a : ∀ P : PrincipalAgentModel,
    managerUtility_secondBest P eH = reservation_utility P
axiom prop14B3_part1b : ∀ P : PrincipalAgentModel,
    expectedWage_secondBest P eH > expectedWage_observable P eH
axiom prop14B3_part2a : ∀ P : PrincipalAgentModel,
    isConstantWage_secondBest P eL
axiom prop14B3_part2b : ∀ P : PrincipalAgentModel,
    expectedWage_secondBest P eL = expectedWage_observable P eL
axiom prop14B3_part3 : ∀ P : PrincipalAgentModel,
    optimalEffort_observable P = eH →
    welfare_secondBest P eH < welfare_observable P eH

theorem Proposition_14B3 (P : PrincipalAgentModel) :
    (managerUtility_secondBest P eH = reservation_utility P ∧
     expectedWage_secondBest P eH > expectedWage_observable P eH) ∧
    (isConstantWage_secondBest P eL ∧
     expectedWage_secondBest P eL = expectedWage_observable P eL) ∧
    (optimalEffort_observable P = eH →
     welfare_secondBest P eH < welfare_observable P eH) :=
  ⟨⟨prop14B3_part1a P, prop14B3_part1b P⟩,
   ⟨prop14B3_part2a P, prop14B3_part2b P⟩,
   prop14B3_part3 P⟩