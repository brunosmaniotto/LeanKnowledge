import Mathlib
open Topology

axiom Mechanism : Type
axiom irvcg : Mechanism

axiom IsIncentiveCompatible : Mechanism → Prop
axiom IsExPostEfficient : Mechanism → Prop
axiom IsBudgetBalanced : Mechanism → Prop
axiom IsIndividuallyRational : Mechanism → Prop
axiom RunsExpectedSurplus : Mechanism → Prop

axiom Reg : Prop

axiom theorem_9_13 : Reg → (RunsExpectedSurplus irvcg → ∃ M : Mechanism, IsIncentiveCompatible M ∧ IsExPostEfficient M ∧ IsBudgetBalanced M ∧ IsIndividuallyRational M)
axiom theorem_9_17 : Reg → (∃ M : Mechanism, IsIncentiveCompatible M ∧ IsExPostEfficient M ∧ IsBudgetBalanced M ∧ IsIndividuallyRational M) → RunsExpectedSurplus irvcg

theorem Claim_IRVCG_iff (hReg : Reg) : (∃ M, IsIncentiveCompatible M ∧ IsExPostEfficient M ∧ IsBudgetBalanced M ∧ IsIndividuallyRational M) ↔ RunsExpectedSurplus irvcg := by
  constructor
  · exact theorem_9_17 hReg
  · intro h
    exact theorem_9_13 hReg h