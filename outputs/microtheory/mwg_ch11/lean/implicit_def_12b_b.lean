import Mathlib

open Real
open Topology

/-
The deadweight loss of monopoly is the welfare loss from the monopolist's
quantity distortion, measured using the change in Marshallian aggregate surplus
(relative to the competitive outcome q°).
-/
def deadweight_loss_of_monopoly
    (aggregate_surplus : ℝ → ℝ)
    (q_monopoly : ℝ)
    (q_competitive : ℝ) : ℝ :=
  aggregate_surplus q_competitive - aggregate_surplus q_monopoly