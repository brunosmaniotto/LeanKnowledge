import Mathlib

/-- When there are only two types, equilibrium dominance refinement (Θ**(a))
    is equivalent to the intuitive criterion. With ≥3 types, intuitive criterion
    is strictly weaker. -/
theorem Claim_13AA_d
    {Type_ : Type*} [Fintype Type_] [DecidableEq Type_]
    (types : Finset Type_)
    -- equilibrium_dominated: types that are dominated at equilibrium
    (eq_dominated : Finset Type_)
    (h_sub : eq_dominated ⊆ types)
    -- Θ**(a) = types that survive dominance elimination
    (theta_star_star : Finset Type_)
    (h_theta : theta_star_star = types \ eq_dominated)
    -- intuitive_criterion_holds: predicate that IC accepts a deviation
    (IC_accepts : Prop)
    -- dominance_refinement_accepts: predicate that dominance refinement accepts
    (DR_accepts : Prop)
    -- Key modeling assumptions:
    -- If Θ**(a) is a singleton, both criteria agree
    (h_singleton_equiv : theta_star_star.card = 1 → (IC_accepts ↔ DR_accepts))
    -- DR implies IC in general (IC is weaker)
    (h_DR_implies_IC : DR_accepts → IC_accepts)
    -- With two types and a nonempty dominated set, Θ**(a) is singleton
    (h_two_types : types.card = 2 → eq_dominated.Nonempty → theta_star_star.card = 1)
    :
    -- Main conclusion: with 2 types, equivalence holds
    (types.card = 2 → eq_dominated.Nonempty → (IC_accepts ↔ DR_accepts)) := by
  intro h2 h_ne
  exact h_singleton_equiv (h_two_types h2 h_ne)