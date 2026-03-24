import Mathlib

/-- For two consumers, the core coincides with the contract curve in the Edgeworth box. -/
theorem core_coincides_with_contract_curve_two_consumers
    (Allocation : Type*)
    (Core ContractCurve ParetoOptimal IndividuallyRational : Set Allocation)
    (h_core : Core = ParetoOptimal ∩ IndividuallyRational)
    (h_cc : ContractCurve = ParetoOptimal ∩ IndividuallyRational) :
    Core = ContractCurve := by
  rw [h_core, h_cc]