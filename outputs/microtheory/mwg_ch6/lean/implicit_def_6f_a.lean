import Mathlib
open Topology
open MeasureTheory

/-- State preference relation on lotteries in state s.
    F_s ≿_s F'_s iff the expected utility under F_s is at least that under F'_s. -/
noncomputable def statePreference
    {X : Type*} [MeasurableSpace X]
    (u_s : X → ℝ)
    (F_s F'_s : MeasureTheory.Measure X)
    : Prop :=
  ∫ x_s, u_s x_s ∂F_s ≥ ∫ x_s, u_s x_s ∂F'_s