import Mathlib

open Set
open scoped symmDiff
open Topology

/-- A policy in the insurance screening game, as a (premium, indemnity) pair. -/
abbrev InsurancePolicy := ℝ × ℝ

/-- Insurance company identifier in the two-company screening game. -/
inductive Insurer
  | A | B
  deriving DecidableEq

/-- A pure strategy for an insurance company j: a pair of policies (ψ^j_l, ψ^j_h),
    one listed for low-risk and one for high-risk consumers. -/
structure CompanyStrategy where
  policyLow  : InsurancePolicy
  policyHigh : InsurancePolicy

/-- The set of policies available to a consumer from insurer j's strategy:
    the two listed policies plus the null policy (0, 0). -/
def availablePolicies (Δ : CompanyStrategy) : Set InsurancePolicy :=
  {Δ.policyLow, Δ.policyHigh, (0, 0)}

/-- The strategies of the insurance screening game (Definition 8.1.3).

    Each insurance company j ∈ {A, B} plays Δ_j = (ψ^j_l, ψ^j_h).
    Each consumer i ∈ {l, h} plays a choice function c_i(Δ_A, Δ_B) = (j, ψ)
    where j ∈ {A, B} and ψ ∈ {ψ^j_l, ψ^j_h, (0, 0)}.
    Consumers always have the option of the null policy (0, 0). -/
structure Implicit_Def_8_1_3_strategies where
  /-- Company A's strategy: pair of policies (ψ^A_l, ψ^A_h) -/
  Delta_A : CompanyStrategy
  /-- Company B's strategy: pair of policies (ψ^B_l, ψ^B_h) -/
  Delta_B : CompanyStrategy
  /-- Low-risk consumer's choice function: maps any (Δ_A, Δ_B) to (insurer, policy) -/
  choice_low  : CompanyStrategy → CompanyStrategy → Insurer × InsurancePolicy
  /-- High-risk consumer's choice function: maps any (Δ_A, Δ_B) to (insurer, policy) -/
  choice_high : CompanyStrategy → CompanyStrategy → Insurer × InsurancePolicy
  /-- Low-risk consumer's choice is valid: selected policy belongs to chosen insurer's available set -/
  choice_low_valid : ∀ ΔA ΔB : CompanyStrategy,
    let c := choice_low ΔA ΔB
    let Δ := match c.1 with | .A => ΔA | .B => ΔB
    c.2 ∈ availablePolicies Δ
  /-- High-risk consumer's choice is valid -/
  choice_high_valid : ∀ ΔA ΔB : CompanyStrategy,
    let c := choice_high ΔA ΔB
    let Δ := match c.1 with | .A => ΔA | .B => ΔB
    c.2 ∈ availablePolicies Δ