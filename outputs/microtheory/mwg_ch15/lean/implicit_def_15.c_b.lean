import Mathlib

structure ConsumerProblem where
  u : ℝ → ℝ → ℝ
  p : ℝ
  w : ℝ
  L : ℝ
  π : ℝ → ℝ → ℝ

def ConsumerProblem.budgetSet (cp : ConsumerProblem) : Set (ℝ × ℝ) :=
  {x | 0 ≤ x.1 ∧ 0 ≤ x.2 ∧ cp.p * x.2 ≤ cp.w * (cp.L - x.1) + cp.π cp.p cp.w}