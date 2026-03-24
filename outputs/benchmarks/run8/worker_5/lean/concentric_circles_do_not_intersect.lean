import Mathlib

open Metric

variable {E : Type _} [MetricSpace E] (c : E) (r₁ r₂ : ℝ)

/-- Two concentric circles that share a point on their circumferences must be the same circle. -/
theorem concentric_spheres_eq_of_intersect 
    (h : ∃ x, x ∈ sphere c r₁ ∧ x ∈ sphere c r₂) : sphere c r₁ = sphere c r₂ := by
  rcases h with ⟨x, hx₁, hx₂⟩
  have hdist₁ : dist x c = r₁ := hx₁
  have hdist₂ : dist x c = r₂ := hx₂
  have hr : r₁ = r₂ := by linarith
  rw [hr]