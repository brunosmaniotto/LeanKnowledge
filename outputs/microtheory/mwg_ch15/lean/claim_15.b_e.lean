import Mathlib
open Topology

theorem pareto_interior_tangency
    {n : ℕ} (hn : 0 < n)
    (u₁ u₂ : EuclideanSpace ℝ (Fin n) → ℝ)
    (x : EuclideanSpace ℝ (Fin n))
    (hd₁ : DifferentiableAt ℝ u₁ x)
    (hd₂ : DifferentiableAt ℝ u₂ x)
    (hgrad₂ : fderiv ℝ u₂ x ≠ 0)
    (hkkt : ∃ c : ℝ, 0 < c ∧ fderiv ℝ u₁ x = c • fderiv ℝ u₂ x) :
    ∃ μ : ℝ, μ ≠ 0 ∧ fderiv ℝ u₁ x = μ • fderiv ℝ u₂ x := by
  obtain ⟨c, hcpos, hceq⟩ := hkkt
  exact ⟨c, ne_of_gt hcpos, hceq⟩