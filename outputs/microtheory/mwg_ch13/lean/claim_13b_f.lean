import Mathlib

theorem competitive_allocation_failure_from_info_asymmetry
    (firmsCanDistinguish : Prop)
    (competitiveAllocationParetoOptimal : Prop)
    (efficientAllocation : Prop)
    (info_asymmetry_prevents_efficiency : ¬firmsCanDistinguish → ¬efficientAllocation)
    (efficiency_necessary_for_optimality : ¬efficientAllocation → ¬competitiveAllocationParetoOptimal)
    (h_cannot_distinguish : ¬firmsCanDistinguish) :
    ¬competitiveAllocationParetoOptimal :=
  efficiency_necessary_for_optimality (info_asymmetry_prevents_efficiency h_cannot_distinguish)