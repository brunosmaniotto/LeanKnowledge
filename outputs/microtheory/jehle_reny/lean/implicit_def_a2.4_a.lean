import Mathlib

open Set
open Topology

/-- Setup for a parameterised constrained maximisation problem (MWG Section A2.4).
    Maximise f(x, a) subject to g_j(x, a) ≤ 0 for j = 1,…,m,
    where x ∈ ℝⁿ are choice variables and a ∈ A ⊆ ℝˡ are parameters. -/
structure ConstrainedOptProblem (n l m : ℕ) where
  /-- The parameter set A ⊆ ℝˡ -/
  A : Set (Fin l → ℝ)
  /-- The m constraint functions g_j : ℝⁿ × ℝˡ → ℝ -/
  g : Fin m → (Fin n → ℝ) → (Fin l → ℝ) → ℝ
  /-- The domain D ⊆ ℝⁿ × ℝˡ on which the objective is defined -/
  D : Set ((Fin n → ℝ) × (Fin l → ℝ))
  /-- The objective function f : D → ℝ -/
  f : (Fin n → ℝ) → (Fin l → ℝ) → ℝ
  /-- The constraint set S is contained in D -/
  constraintSet_subset : ∀ x a, a ∈ A → (∀ j, g j x a ≤ 0) → (x, a) ∈ D
  /-- For every a ∈ A there is at least one feasible x -/
  feasible : ∀ a ∈ A, ∃ x : Fin n → ℝ, ∀ j, g j x a ≤ 0

/-- The constraint set S = {(x, a) | a ∈ A ∧ ∀ j, g_j(x, a) ≤ 0}. -/
def MWG.ConstraintSet (P : ConstrainedOptProblem n l m) :
    Set ((Fin n → ℝ) × (Fin l → ℝ)) :=
  {p | p.2 ∈ P.A ∧ ∀ j, P.g j p.1 p.2 ≤ 0}