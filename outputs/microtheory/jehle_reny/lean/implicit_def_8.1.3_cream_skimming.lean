import Mathlib
open Topology

/-- Cream skimming occurs when one insurance company strategically offers a policy
that attracts only low-risk consumers away from a competitor, leaving the competitor
with only high-risk consumers. In equilibrium, no firm can profitably skim another's
cream. At least two firms are required for cream skimming to be a strategic concern. -/
structure CreamSkimming where
  /-- Number of insurance firms in the market -/
  numFirms : ℕ
  /-- At least two firms are required for cream skimming to be a strategic concern -/
  hFirms : 2 ≤ numFirms
  /-- Consumer risk type, parameterized as a probability of loss in [0,1] -/
  riskType : Type*
  /-- A linear order on risk types (lower = better for the insurer) -/
  instOrd : LinearOrder riskType
  /-- A policy is represented by a premium-coverage pair -/
  Policy : Type*
  /-- The set of policies offered by each firm -/
  offerings : Fin numFirms → Set Policy
  /-- Consumer preference: a consumer of given risk type prefers one policy over another -/
  prefers : riskType → Policy → Policy → Prop
  /-- Risk threshold: partitions consumers into low-risk and high-risk -/
  isLowRisk : riskType → Prop
  /-- Decidable membership in low-risk class -/
  decLowRisk : DecidablePred isLowRisk
  /-- A cream-skimming policy attracts all low-risk consumers away from a target firm -/
  skims : Policy → Fin numFirms → Prop
  /-- Skimming means every low-risk consumer prefers the raiding policy
      over every policy in the target firm's offering -/
  skim_attracts_low : ∀ p target, skims p target →
    ∀ r, isLowRisk r → ∀ q ∈ offerings target, prefers r p q
  /-- Skimming means no high-risk consumer prefers the raiding policy
      over their best option in the target firm's offering -/
  skim_repels_high : ∀ p target, skims p target →
    ∀ r, ¬isLowRisk r → ∃ q ∈ offerings target, ¬prefers r p q

/-- An equilibrium is immune to cream skimming: no outside policy can skim
    any firm's low-risk consumers. -/
def G.is_equilibrium (cs : CreamSkimming) : Prop :=
  ∀ p : cs.Policy, ∀ target : Fin cs.numFirms, ¬cs.skims p target