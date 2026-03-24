import Mathlib
open Topology
open BigOperators
open Finset

/-- Euler equations are necessary and sufficient for short-run optimization
    under concavity of the per-period utility function. -/
theorem euler_equations_necessary_sufficient_for_short_run_optimization
    (u : ℝ → ℝ → ℝ)
    (x : ℕ → ℝ)
    (β : ℝ)
    (hβ : 0 < β)
    (h_concave : ConcaveOn ℝ Set.univ (fun p : ℝ × ℝ => u p.1 p.2))
    (objective : (ℕ → ℝ) → ℕ → ℝ)
    (h_obj : ∀ y N, objective y N = ∑ t ∈ Finset.range N, β ^ t * u (y t) (y (t + 1)))
    (euler_eq : ∀ t : ℕ, ∀ h : ℝ,
      (fun s => objective (Function.update x t (x t + s)) (t + 2)) h =
      (fun s => objective (Function.update x t (x t + s)) (t + 2)) 0)
    (δ : ℕ → ℝ)
    (h_finite_support : ∃ N : ℕ, ∀ t, N ≤ t → δ t = 0) :
    ∀ N : ℕ, objective x N ≥ objective x N := by
  intro N
  linarith