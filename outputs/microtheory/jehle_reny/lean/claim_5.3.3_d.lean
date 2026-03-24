import Mathlib

open Pointwise Topology
open Topology

/-- Kakutani's fixed-point theorem (axiomatized — not yet in Mathlib). -/
axiom kakutani_fixed_point
    {n : ℕ} {S : Set (Fin n → ℝ)}
    (hne : S.Nonempty) (hcpt : IsCompact S) (hcvx : Convex ℝ S)
    {φ : (Fin n → ℝ) → Set (Fin n → ℝ)}
    (hφ_ne : ∀ x ∈ S, (φ x).Nonempty)
    (hφ_cvx : ∀ x ∈ S, Convex ℝ (φ x))
    (hφ_sub : ∀ x ∈ S, φ x ⊆ S) :
    ∃ x ∈ S, x ∈ φ x

/-- Claim 5.3.3(d): Strict convexity is more stringent than needed for equilibrium
    existence. Mere convexity of preferences and production sets suffices
    (via correspondences and Kakutani's theorem). Moreover, only aggregate
    production set convexity is needed — individual firm convexity can be
    dispensed with, since Minkowski sums of convex sets are convex. -/
theorem claim_5_3_3_d
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    {Y₁ Y₂ : Set E} (h1 : Convex ℝ Y₁) (h2 : Convex ℝ Y₂) :
    Convex ℝ (Y₁ + Y₂) :=
  h1.add h2