import Mathlib
open Topology

/-- A compound gamble over outcomes in `A`. A compound gamble is either a pure
    outcome or a finite probability mixture of compound gambles. The inductive
    structure ensures only finitely many layers of randomisation occur. -/
inductive CompoundGamble (A : Type*) where
  /-- A degenerate gamble yielding a certain outcome in `A`. -/
  | pure (outcome : A) : CompoundGamble A
  /-- A randomisation over finitely many compound gambles, each assigned a weight. -/
  | mix (n : ℕ) (weights : Fin n → ℝ) (prizes : Fin n → CompoundGamble A)
      : CompoundGamble A