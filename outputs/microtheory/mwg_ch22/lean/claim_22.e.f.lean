import Mathlib
open Topology

theorem utilitarian_solution_consistent
    (w₁ w₂ : ℝ) (hw₁ : 0 < w₁) (hw₂ : 0 < w₂)
    (S : Set (ℝ × ℝ))
    (u_star : ℝ × ℝ) (hu_in : u_star ∈ S)
    (hu_opt : ∀ u ∈ S, w₁ * u.1 + w₂ * u.2 ≤ w₁ * u_star.1 + w₂ * u_star.2)
    : ∀ u₁ : ℝ, (u₁, u_star.2) ∈ S → w₁ * u₁ ≤ w₁ * u_star.1 := by
  intro u₁ hu₁
  have h := hu_opt (u₁, u_star.2) hu₁
  linarith