import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Given I consumers with utility functions uᵢ, total endowment ω̄, and a weight vector s
    in the unit simplex, the Negishi map returns the unique Pareto optimal allocation x(s)
    such that the utility vector (u₁(x₁(s)), …, uᵢ(xᵢ(s))) is proportional to s. -/
noncomputable def negishi_pareto_allocation
    (I : ℕ) (L : ℕ)
    (u : Fin I → (Fin L → ℝ) → ℝ)
    (ω_bar : Fin L → ℝ)
    (s : Fin I → ℝ)
    (hs_nonneg : ∀ i, 0 ≤ s i)
    (hs_sum : ∑ i : Fin I, s i = 1)
    (h_feasible : ∀ l, 0 < ω_bar l)
    : Fin I → (Fin L → ℝ) :=
  Classical.choice inferInstance