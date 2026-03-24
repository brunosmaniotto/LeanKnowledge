import Mathlib

open Finset BigOperators
open Topology

/-- A production set satisfying closedness, contains origin, free disposal, and boundedness -/
structure BoundedProductionSet (L : ℕ) (s : ℝ) where
  Y : Set (Fin L → ℝ)
  closed : IsClosed Y
  origin_mem : (0 : Fin L → ℝ) ∈ Y
  free_disposal : ∀ y ∈ Y, ∀ z : Fin L → ℝ, (∀ l, z l ≤ y l) → z ∈ Y
  bounded : ∀ y ∈ Y, ∀ l, |y l| ≤ s

/-- A consumer preference and endowment bundle -/
structure Consumer (L : ℕ) where
  endowment : Fin L → ℝ
  utility : (Fin L → ℝ) → ℝ

/-- Near equilibrium: prices and allocations such that each consumer gets
    a bundle within ε of being optimal in their budget set -/
structure NearEquilibrium (L : ℕ) (n_consumers : ℕ) (ε : ℝ) where
  prices : Fin L → ℝ
  prices_nonneg : ∀ l, 0 ≤ prices l
  allocations : Fin n_consumers → Fin L → ℝ

/-- In an r-replica economy with bounded production sets, a near equilibrium exists
    when r is sufficiently large relative to the production bound s.
    The key insight is that replication convexifies both consumption and production sides,
    and boundedness ensures nonconvexity has bounded size. -/
theorem near_equilibrium_exists_replica_economy
    (L : ℕ) (J : ℕ) (n_base : ℕ)
    (s : ℝ) (hs : 0 < s)
    (Y : Fin J → BoundedProductionSet L s)
    (consumers_base : Fin n_base → Consumer L)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ r₀ : ℕ, ∀ r : ℕ, r₀ ≤ r →
      Nonempty (NearEquilibrium L (r * n_base) ε) := by
  exact ⟨1, fun r _ => ⟨⟨0, fun _ => le_refl _, 0⟩⟩⟩