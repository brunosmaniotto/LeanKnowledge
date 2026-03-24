import Mathlib

open MeasureTheory

/-- Problem 14.B.9: Optimal incentive scheme under moral hazard (unobservable effort). -/
structure MoralHazardProblem where
  Ω : Type*
  measΩ : MeasurableSpace Ω
  E : Type*
  v : ℝ → ℝ
  g : E → ℝ
  f : E → Measure Ω
  u_bar : ℝ
  e : E

noncomputable def expectedWage (P : MoralHazardProblem) (w : P.Ω → ℝ) (e : P.E) : ℝ :=
  ∫ ω, w ω ∂(P.f e)

noncomputable def managerUtility (P : MoralHazardProblem) (w : P.Ω → ℝ) (e : P.E) : ℝ :=
  ∫ ω, P.v (w ω) ∂(P.f e) - P.g e

/-- An incentive scheme w is optimal for implementing effort e under moral hazard:
    it minimizes expected wages subject to participation and incentive constraints. -/
structure MoralHazardProblem.IsOptimal (P : MoralHazardProblem) (w : P.Ω → ℝ) : Prop where
  participation : managerUtility P w P.e ≥ P.u_bar
  incentive : ∀ ê : P.E, managerUtility P w P.e ≥ managerUtility P w ê
  minimizes : ∀ w' : P.Ω → ℝ,
    managerUtility P w' P.e ≥ P.u_bar →
    (∀ ê : P.E, managerUtility P w' P.e ≥ managerUtility P w' ê) →
    expectedWage P w P.e ≤ expectedWage P w' P.e