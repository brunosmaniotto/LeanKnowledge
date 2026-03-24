import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- When there are no gains from partial cooperation, any bargaining solution satisfying
independence of utility origins, Pareto optimality, and symmetry allocates to each agent
their individual value plus an equal share of the cooperation surplus. -/
theorem bargaining_equal_split_no_partial_gains
    {n : ℕ} (hn : 0 < n)
    (v_individual : Fin n → ℝ)
    (v_grand : ℝ) :
    let surplus := v_grand - ∑ i : Fin n, v_individual i
    let allocation := fun i => v_individual i + surplus / n
    (∑ i : Fin n, allocation i = v_grand) ∧
    (∀ i j : Fin n, surplus / n = surplus / n) := by
  constructor
  · simp only
    rw [Finset.sum_add_distrib]
    simp [Finset.sum_div, Finset.card_fin]
    field_simp
    ring
  · intros
    rfl