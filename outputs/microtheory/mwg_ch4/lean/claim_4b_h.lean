import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Aggregate demand depends only on the statistical distribution of wealth
    when all consumers have identical preferences. -/
theorem aggregate_demand_depends_on_wealth_distribution
    {n : ℕ} {G : Type*} [AddCommMonoid G]
    (x : ℝ → G)
    (w₁ w₂ : Fin n → ℝ)
    (h : Finset.univ.val.map w₁ = Finset.univ.val.map w₂)
    : ∑ i : Fin n, x (w₁ i) = ∑ i : Fin n, x (w₂ i) := by
  show (univ.val.map (x ∘ w₁)).sum = (univ.val.map (x ∘ w₂)).sum
  congr 1
  rw [← Multiset.map_map, ← Multiset.map_map, h]