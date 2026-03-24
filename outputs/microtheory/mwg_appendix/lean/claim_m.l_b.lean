import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem envelope_theorem_binding_constraints
    {n : ℕ} (m : ℕ)
    (μ : Fin m → ℝ)
    (Dg : Fin m → Fin n → ℝ)
    (binding : Finset (Fin m))
    (nonbinding_zero : ∀ j, j ∉ binding → μ j = 0) :
    ∑ j : Fin m, μ j • (fun i => Dg j i) =
    ∑ j ∈ binding, μ j • (fun i => Dg j i) := by
  have key : ∀ j : Fin m, j ∉ binding → μ j • (fun i => Dg j i) = 0 := by
    intro j hj
    simp [nonbinding_zero j hj]
  rw [← Finset.sum_subset (Finset.subset_univ binding) (fun j _ hj => key j hj)]