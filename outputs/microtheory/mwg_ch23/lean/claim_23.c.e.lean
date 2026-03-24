import Mathlib

/-- When ℛ_i = P for all i (unrestricted domain), any ex post efficient
    social choice function must have f(Θ) = X, i.e., f is surjective. -/
theorem claim_23_C_e
    {X Θ Agent : Type*} [Nonempty Agent]
    (R : Θ → Agent → X → X → Prop)
    (f : Θ → X)
    -- Unrestricted domain: for each x, ∃ a profile where x is uniquely top-ranked
    (h_unrestricted : ∀ x : X, ∃ θ : Θ,
      (∀ i : Agent, ∀ y : X, R θ i x y) ∧
      (∀ y : X, (∀ i : Agent, R θ i y x) → y = x))
    -- Ex post efficiency: when x is the unique Pareto optimum, f selects it
    (h_eff : ∀ θ x, (∀ i : Agent, ∀ y : X, R θ i x y) →
      (∀ y, (∀ i, R θ i y x) → y = x) → f θ = x) :
    Function.Surjective f := by
  intro x
  obtain ⟨θ, htop, huniq⟩ := h_unrestricted x
  exact ⟨θ, h_eff θ x htop huniq⟩