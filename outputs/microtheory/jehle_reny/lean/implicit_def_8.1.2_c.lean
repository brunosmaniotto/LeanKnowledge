import Mathlib
open Topology

/-- Response of the insurance company to a proposed policy. -/
inductive InsuranceResponse
  | Accept
  | Reject
  deriving DecidableEq, Inhabited

/-- Strategies and beliefs for the insurance signaling game (Definition 8.1.2).
    Each consumer type proposes a policy (benefit, premium).
    The insurance company's pure strategy is a response function
    mapping policies to Accept/Reject, independent of consumer risk type.
    Beliefs assign the probability of facing the low-risk consumer
    given each proposed policy. -/
structure InsuranceSignalingGame where
  /-- Low-risk consumer's pure strategy: a policy (benefit, premium) -/
  strategyLow : ℝ × ℝ
  /-- High-risk consumer's pure strategy: a policy (benefit, premium) -/
  strategyHigh : ℝ × ℝ
  /-- Insurance company's pure strategy: response function on policies -/
  companyStrategy : ℝ × ℝ → InsuranceResponse
  /-- Insurance company's beliefs: probability of facing low-risk given policy (B, p) -/
  beliefs : ℝ × ℝ → ℝ
  /-- Beliefs are non-negative -/
  beliefs_nonneg : ∀ Bp, 0 ≤ beliefs Bp
  /-- Beliefs are at most one -/
  beliefs_le_one : ∀ Bp, beliefs Bp ≤ 1