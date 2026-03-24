import Mathlib

open MeasureTheory InnerProductSpace
open Topology

variable {n : ℕ}

/-- Fraction of population with density g preferring y to z. -/
noncomputable def m_g (g : EuclideanSpace ℝ (Fin n) → ℝ)
    (y z : EuclideanSpace ℝ (Fin n)) : ℝ :=
  ∫ x, if dist x y < dist x z then g x else 0

/-- A point is a median if every halfspace through it has mass ≥ 1/2. -/
def IsMedian (g : EuclideanSpace ℝ (Fin n) → ℝ) (x₀ : EuclideanSpace ℝ (Fin n)) : Prop :=
  ∀ v : EuclideanSpace ℝ (Fin n), v ≠ 0 →
    (∫ x, if @inner ℝ _ _ v (x - x₀) ≤ 0 then g x else 0) ≥ 1 / 2