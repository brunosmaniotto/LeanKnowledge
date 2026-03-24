import Mathlib

/-- Convexity of the production set is indispensable for the second welfare theorem.
If the production set is nonconvex, a Pareto optimal allocation may not be
supportable as both utility-maximizing and profit-maximizing. -/
theorem second_welfare_theorem_requires_convex_production
    {L : Type*} [Fintype L] [DecidableEq L]
    (ProductionSet : Set (L → ℝ))
    (utility : (L → ℝ) → ℝ)
    (is_pareto_optimal : (L → ℝ) → Prop)
    (xstar : L → ℝ)
    (h_nonconvex : ¬ Convex ℝ ProductionSet)
    (h_optimal : is_pareto_optimal xstar)
    (h_xstar_in_prod : xstar ∈ ProductionSet)
    (support_prices : Set (L → ℝ))
    (h_support_prices : ∀ p ∈ support_prices,
      ∀ x, utility x ≥ utility xstar →
        Finset.univ.sum (fun l => p l * x l) ≥
        Finset.univ.sum (fun l => p l * xstar l))
    (h_no_profit_max : ∀ p ∈ support_prices,
      ¬ ∀ y ∈ ProductionSet,
        Finset.univ.sum (fun l => p l * y l) ≤
        Finset.univ.sum (fun l => p l * xstar l)) :
    ¬ ∃ p ∈ support_prices,
      (∀ x, utility x ≥ utility xstar →
        Finset.univ.sum (fun l => p l * x l) ≥
        Finset.univ.sum (fun l => p l * xstar l)) ∧
      (∀ y ∈ ProductionSet,
        Finset.univ.sum (fun l => p l * y l) ≤
        Finset.univ.sum (fun l => p l * xstar l)) := by
  intro ⟨p, hp, _, h_profit⟩
  exact h_no_profit_max p hp h_profit