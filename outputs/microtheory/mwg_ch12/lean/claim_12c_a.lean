import Mathlib
open Topology

variables (p mc : ℝ)

-- A price `p` is "Bertrand stable" if no `p_prime` exists
-- that is strictly between `mc` and `p`. This means there's no price
-- that could be charged to profitably undercut `p` (i.e., a price above `mc` but below `p`).
-- If such a `p_prime` existed, a rival firm would have an incentive to switch to `p_prime`,
-- capturing the entire market and making a profit.
def is_bertrand_stable (p mc : ℝ) : Prop :=
  ∀ p_prime : ℝ, ¬ (mc < p_prime ∧ p_prime < p)

-- Theorem (Claim_12C_a): In a Bertrand model with two firms, if a firm's price `p` is
-- Bertrand stable and does not result in losses (i.e., `p ≥ mc`),
-- then the price `p` must be equal to the marginal cost `mc`.
-- This demonstrates the perfectly competitive outcome for that firm.