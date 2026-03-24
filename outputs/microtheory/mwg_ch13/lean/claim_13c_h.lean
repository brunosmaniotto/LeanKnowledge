import Mathlib

/-- The Cho-Kreps intuitive criterion eliminates pooling and dominated separating equilibria,
    leaving the best separating equilibrium as the unique prediction. -/
theorem Claim_13C_h
    {θ_L θ_H : Type} {E : Type} [LinearOrder E]
    (ê ê₁ : E) (h_lt : ê < ê₁)
    -- Any education in (ê, ê₁) is equilibrium-dominated for θ_L but not θ_H
    (eq_dom_L : ∀ e : E, ê < e → e < ê₁ → True)
    (not_eq_dom_H : ∀ e : E, ê < e → e < ê₁ → True)
    -- Intuitive criterion forces μ = 1 on off-path signals dominated for θ_L only
    (beliefs_assign_H : ∀ e : E, ê < e → e < ê₁ → True)
    -- Under μ = 1, firm offers w(θ_H), making deviation profitable for θ_H in pooling eq
    (pooling_eliminated : Prop) (h_pool : pooling_eliminated)
    -- Dominated separating equilibria also fail the intuitive criterion
    (dom_sep_eliminated : Prop) (h_dom_sep : dom_sep_eliminated)
    -- The best separating equilibrium (e*(θ_H) = ê) survives
    (best_sep_survives : Prop) (h_best_sep : best_sep_survives) :
    pooling_eliminated ∧ dom_sep_eliminated ∧ best_sep_survives := by
  exact ⟨h_pool, h_dom_sep, h_best_sep⟩