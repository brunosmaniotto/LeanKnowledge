import Mathlib
open Topology

/-- A bilateral externality model with private information.
The consumer has type η and derived utility φ(h, η) from externality level h.
The firm has type θ and derived profit π(h, θ).
Both are strictly concave in h. -/
structure BilateralExternalityModel where
  /-- Consumer's derived utility from externality level h and consumer type η -/
  φ : ℝ → ℝ → ℝ
  /-- Firm's derived profit from externality level h and firm type θ -/
  π : ℝ → ℝ → ℝ
  /-- φ(·, η) is strictly concave in h for each consumer type η -/
  φ_strictConcave : ∀ η : ℝ, StrictConcaveOn ℝ Set.univ (fun h => φ h η)
  /-- π(·, θ) is strictly concave in h for each firm type θ -/
  π_strictConcave : ∀ θ : ℝ, StrictConcaveOn ℝ Set.univ (fun h => π h θ)