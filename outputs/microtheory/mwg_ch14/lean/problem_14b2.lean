import Mathlib

open MeasureTheory

structure CompensationProblem where
  v : ℝ → ℝ
  g : ℝ → ℝ
  u_bar : ℝ
  μ : ℝ → Measure ℝ

noncomputable def CompensationProblem.expectedCost (P : CompensationProblem) (w : ℝ → ℝ) (e : ℝ) : ℝ :=
  ∫ π, w π ∂(P.μ e)

def CompensationProblem.satisfiesPC (P : CompensationProblem) (w : ℝ → ℝ) (e : ℝ) : Prop :=
  ∫ π, P.v (w π) ∂(P.μ e) - P.g e ≥ P.u_bar