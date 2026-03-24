import Mathlib
open Topology

/-- Consumer type selected by Nature at the start of the signalling game. -/
inductive ConsumerType
  | lowRisk
  | highRisk

/-- The insurer's action upon observing a proposed policy. -/
inductive InsurerAction
  | accept
  | reject

/-- A proposed insurance policy with benefit B (paid if accident) and premium p (paid regardless). -/
structure Policy where
  /-- Benefit paid if accident occurs -/
  B : ℝ
  /-- Premium paid regardless of accident -/
  p : ℝ

/-- A policy is valid given initial wealth `w` if B ≥ 0 and 0 ≤ p ≤ w. -/
def Policy.Valid (pol : Policy) (w : ℝ) : Prop :=
  0 ≤ pol.B ∧ 0 ≤ pol.p ∧ pol.p ≤ w

/-- The insurance signalling game in extensive form.

The game proceeds in three stages:
1. Nature selects `ConsumerType.lowRisk` with probability `α`
   and `ConsumerType.highRisk` with probability `1 - α`.
2. The selected consumer proposes a `Policy` `(B, p)` satisfying `Policy.Valid`.
3. The insurer, observing only the proposed policy (not the consumer type),
   chooses `InsurerAction.accept` or `InsurerAction.reject`. -/
structure InsuranceSignallingGame where
  /-- Initial wealth of the consumer -/
  w : ℝ
  /-- Probability that Nature selects the low-risk type -/
  α : ℝ
  hw_pos : 0 < w
  hα_pos : 0 < α
  hα_lt : α < 1