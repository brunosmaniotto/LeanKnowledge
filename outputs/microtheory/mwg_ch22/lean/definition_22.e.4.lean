import Mathlib
open Topology

/-- A bargaining solution f satisfies the Pareto property (P) if for every bargaining set U,
    f(U) is a weak Pareto optimum: there is no u ∈ U that strictly dominates f(U) in every component. -/
def satisfies_pareto_property {n : ℕ} (f : (Set (Fin n → ℝ)) → (Fin n → ℝ)) : Prop :=
  ∀ (U : Set (Fin n → ℝ)), ¬ ∃ u ∈ U, ∀ i : Fin n, u i > f U i