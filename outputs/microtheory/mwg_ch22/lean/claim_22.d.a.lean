import Mathlib
open Topology

-- Model utility profiles as functions from agents to ℝ
-- A social preference relation satisfying the Pareto property is monotone:
-- if u' ≥ u componentwise then u' is socially at least as good as u,
-- and if u' > u strictly then u' is strictly preferred.

theorem claim_22_D_a
    {I : Type*} [Fintype I] [Nonempty I]
    (R : (I → ℝ) → (I → ℝ) → Prop)
    (R_strict : (I → ℝ) → (I → ℝ) → Prop)
    -- Pareto property: if everyone weakly prefers u' to u, then society does too
    (pareto_weak : ∀ u u' : I → ℝ, (∀ i, u i ≤ u' i) → R u' u)
    -- Strong Pareto: if everyone weakly prefers and someone strictly prefers, then strict social preference
    (pareto_strong : ∀ u u' : I → ℝ, (∀ i, u i ≤ u' i) → (∃ i, u i < u' i) → R_strict u' u) :
    -- Monotonicity conclusions:
    -- (1) u' ≥ u → R u' u
    (∀ u u' : I → ℝ, (∀ i, u i ≤ u' i) → R u' u) ∧
    -- (2) u' > u → R_strict u' u
    (∀ u u' : I → ℝ, (∀ i, u i < u' i) → R_strict u' u) := by
  constructor
  · exact fun u u' h => pareto_weak u u' h
  · intro u u' h
    have hweak : ∀ i, u i ≤ u' i := fun i => le_of_lt (h i)
    have ⟨i⟩ := ‹Nonempty I›
    exact pareto_strong u u' hweak ⟨i, h i⟩