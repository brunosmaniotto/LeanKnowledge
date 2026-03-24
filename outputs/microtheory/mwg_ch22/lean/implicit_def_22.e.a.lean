import Mathlib

open Set

/-- A bargaining problem among `I` agents. -/
structure BargainingProblem (I : Type*) [Fintype I] where
  /-- The utility possibility set. -/
  U : Set (I → ℝ)
  /-- The threat/status-quo point. -/
  u_star : I → ℝ
  /-- u* is in U. -/
  u_star_mem : u_star ∈ U
  /-- U is convex. -/
  U_convex : Convex ℝ U
  /-- U is closed. -/
  U_closed : IsClosed U
  /-- Comprehensive: U - ℝ₊ᴵ ⊆ U (if u ∈ U and v ≤ u then v ∈ U). -/
  U_comprehensive : ∀ u ∈ U, ∀ v : I → ℝ, (∀ i, v i ≤ u i) → v ∈ U
  /-- u* is interior to U. -/
  u_star_interior : u_star ∈ interior U
  /-- The set {u ∈ U : u ≥ u*} is bounded. -/
  individually_rational_bounded : Bornology.IsBounded {u ∈ U | ∀ i, u_star i ≤ u i}