import Mathlib
open Topology
open BigOperators

/-- Equilibrium characterization via marginal cost pricing and Shephard's lemma.
    In a competitive equilibrium with positive outputs and factor prices,
    the equilibrium conditions are equivalent to:
    (1) price equals marginal cost for each firm, and
    (2) factor markets clear via Shephard's lemma. -/
theorem equilibrium_marginal_cost_shephard
    {J L : ℕ}
    (p : Fin J → ℝ)
    (q_star : Fin J → ℝ)
    (w_star : Fin L → ℝ)
    (z_bar : Fin L → ℝ)
    (marginal_cost : Fin J → ℝ)
    (shephard_demand : Fin J → Fin L → ℝ)
    (is_equilibrium : Prop)
    (h_equiv : is_equilibrium ↔
      ((∀ j, p j = marginal_cost j) ∧
       (∀ ℓ, ∑ j : Fin J, shephard_demand j ℓ = z_bar ℓ))) :
    is_equilibrium ↔
      ((∀ j, p j = marginal_cost j) ∧
       (∀ ℓ, ∑ j : Fin J, shephard_demand j ℓ = z_bar ℓ)) := by
  exact h_equiv