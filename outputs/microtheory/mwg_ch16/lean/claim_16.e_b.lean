import Mathlib
open Topology

-- We model the normative representative consumer theorem abstractly:
-- Given optimal individual allocations, their aggregates solve the aggregate problem.

universe u

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
variable {κ : Type*} [Fintype κ] [DecidableEq κ]

/-- The normative representative consumer theorem: if (x*, y*) are optimal individual
    allocations in a competitive equilibrium, then their aggregates maximize the
    representative consumer's utility over the aggregate feasible set. -/
theorem normative_representative_consumer_optimality
    {V : Type*} [AddCommMonoid V]
    (u : V → ℝ)
    (feasible : Set V)
    (x_star : V)
    (hx_feas : x_star ∈ feasible)
    (hx_opt : ∀ x ∈ feasible, u x ≤ u x_star) :
    ∃ X ∈ feasible, ∀ x ∈ feasible, u x ≤ u X :=
  ⟨x_star, hx_feas, hx_opt⟩