import Mathlib

open MeasureTheory

inductive EffortLevel where
  | low  : EffortLevel
  | high : EffortLevel
  deriving DecidableEq

structure ObservableEffortProblem where
  f     : ℝ → EffortLevel → ℝ
  v     : ℝ → ℝ
  g     : EffortLevel → ℝ
  u_bar : ℝ

structure Contract where
  e : EffortLevel
  w : ℝ → ℝ

noncomputable def expectedProfit (P : ObservableEffortProblem) (c : Contract) : ℝ :=
  ∫ π, (π - c.w π) * P.f π c.e

noncomputable def expectedUtility (P : ObservableEffortProblem) (c : Contract) : ℝ :=
  (∫ π, P.v (c.w π) * P.f π c.e) - P.g c.e

def participationConstraint (P : ObservableEffortProblem) (c : Contract) : Prop :=
  expectedUtility P c ≥ P.u_bar