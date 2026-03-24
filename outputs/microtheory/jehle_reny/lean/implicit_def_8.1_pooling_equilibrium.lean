import Mathlib

/-- A pooling equilibrium in an insurance signalling game: both consumer types
    (high-risk and low-risk) propose the same insurance policy, so the insurer
    cannot distinguish between them. -/
structure PoolingEquilibrium (Policy : Type*) where
  /-- The policy chosen by the low-risk type -/
  policy_low : Policy
  /-- The policy chosen by the high-risk type -/
  policy_high : Policy
  /-- Both types propose the same policy -/
  pooling : policy_low = policy_high