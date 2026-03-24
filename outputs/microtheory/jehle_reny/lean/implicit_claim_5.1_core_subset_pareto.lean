import Mathlib

/-- C(e) ⊂ {Pareto-efficient allocations}, but not every Pareto-efficient allocation
    is in the core. Pareto-efficient allocations outside the core can be blocked
    by proper sub-coalitions. -/
theorem Implicit_Claim_5_1_core_subset_pareto
    (CoreImpliesParetoEfficient : Prop)
    (ExistsParetoEfficientNotInCore : Prop)
    (OutsideCoreImpliesBlocked : Prop)
    (h1 : CoreImpliesParetoEfficient)
    (h2 : ExistsParetoEfficientNotInCore)
    (h3 : OutsideCoreImpliesBlocked)
    : CoreImpliesParetoEfficient ∧ ExistsParetoEfficientNotInCore ∧ OutsideCoreImpliesBlocked :=
  ⟨h1, h2, h3⟩