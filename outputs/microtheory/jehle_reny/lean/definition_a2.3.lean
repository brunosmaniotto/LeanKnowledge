import Mathlib

open Filter Topology
open Topology

/-- MWG Definition A2.3: Constraint-continuity for parametric inequality constraints.
    Given m constraint functions g_j : ℝⁿ × A → ℝ, constraint-continuity holds if
    (1) each g_j is jointly continuous, and
    (2) for every feasible (x₀, a₀) and every sequence aᵏ → a₀, there exists
        a sequence xᵏ → x₀ such that (xᵏ, aᵏ) is feasible for all k. -/
def MWG.ConstraintQualificationInequality
    {n m : ℕ}
    {A : Type*} [TopologicalSpace A]
    (g : Fin m → (EuclideanSpace ℝ (Fin n) → A → ℝ)) : Prop :=
  (∀ j, Continuous (fun p : EuclideanSpace ℝ (Fin n) × A => g j p.1 p.2)) ∧
  (∀ (x₀ : EuclideanSpace ℝ (Fin n)) (a₀ : A),
    (∀ j, g j x₀ a₀ ≤ 0) →
    ∀ (a : ℕ → A), Tendsto a atTop (𝓝 a₀) →
      ∃ (x : ℕ → EuclideanSpace ℝ (Fin n)),
        Tendsto x atTop (𝓝 x₀) ∧
        ∀ k, ∀ j, g j (x k) (a k) ≤ 0)