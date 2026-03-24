import Mathlib
open Topology
set_option linter.unusedVariables false

axiom payment : ℝ → ℝ
axiom payment_monotone : ∀ x y, |x| ≤ |y| → payment x ≤ payment y

theorem Claim_9_5_5_d : ∀ (r1 r2 : ℝ), |r1| ≤ |r2| → payment r1 ≤ payment r2 :=
  fun r1 r2 h => payment_monotone r1 r2 h