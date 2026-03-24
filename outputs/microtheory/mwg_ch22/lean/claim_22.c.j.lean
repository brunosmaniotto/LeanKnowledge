import Mathlib

open Finset
open Topology

/-- A maximin SWF selects allocations maximizing the minimum utility.
    Any equal-utility vector on the Pareto frontier is a maximin optimum,
    since no other feasible point can have a strictly higher minimum. -/
theorem maximin_equal_utility_optimal
    {n : ℕ} (hn : 0 < n)
    (U : Set (Fin n → ℝ))
    (u_eq : Fin n → ℝ)
    (h_eq : ∀ i j : Fin n, u_eq i = u_eq j)
    (h_mem : u_eq ∈ U)
    (h_pareto : ∀ v ∈ U, (∀ i, u_eq i ≤ v i) → ∀ i, v i = u_eq i) :
    ∀ v ∈ U, ∃ i : Fin n, v i ≤ u_eq i := by
  intro v hv
  by_contra h
  push_neg at h
  have : ∀ i, u_eq i ≤ v i := by
    intro i
    exact le_of_lt (h i)
  have := h_pareto v hv this
  have i₀ : Fin n := ⟨0, hn⟩
  linarith [h i₀, this i₀]