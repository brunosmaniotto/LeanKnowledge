import Mathlib
open Topology

/-- An insurance policy specified by premium and coverage. -/
structure InsurancePolicy where
  premium : ℝ
  coverage : ℝ

/-- Risk type of the consumer. -/
inductive RiskType where
  | low
  | high

/-- The null policy: no insurance (zero premium, zero coverage). -/
def InsurancePolicy.null : InsurancePolicy := ⟨0, 0⟩

/-- The insurance screening game is an extensive form game:
    (1) Two companies simultaneously choose finite menus (lists) of policies.
    (2) Nature determines consumer type: low-risk (prob α) or high-risk (prob 1 − α).
    (3) The consumer selects a single policy from the offered menus or the null policy. -/
structure ScreeningGame where
  /-- Probability of the low-risk consumer type -/
  α : ℝ
  hα_pos : 0 < α
  hα_lt : α < 1
  /-- Company 1's offered menu of policies -/
  menu₁ : List InsurancePolicy
  /-- Company 2's offered menu of policies -/
  menu₂ : List InsurancePolicy
  /-- Profit to a company from a policy given the consumer's risk type -/
  companyProfit : InsurancePolicy → RiskType → ℝ
  /-- Consumer utility from a policy given own risk type -/
  consumerUtility : InsurancePolicy → RiskType → ℝ