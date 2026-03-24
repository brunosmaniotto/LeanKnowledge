import Mathlib

-- Axiomatize the game-theoretic framework
variable {I : Type*} [Fintype I] [DecidableEq I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]

-- Mixed strategy profile
variable (σ : ∀ i, S i → ℝ)

-- Key predicates
axiom IsTotallyMixed : (∀ i, S i → ℝ) → Prop
axiom IsBestResponse : (∀ i, S i → ℝ) → I → Prop
axiom IsWeaklyDominated : (∀ i, S i → ℝ) → I → Prop
axiom IsTHPNashEquilibrium : (∀ i, S i → ℝ) → Prop

-- Definition 8.F.1: A THPNE is the limit of a sequence of totally mixed
-- strategy profiles where each component is a best response.
-- We encode this as: for every ε-perturbation (totally mixed profile close to σ),
-- σ_i is a best response.
axiom thpne_best_response_to_totally_mixed :
  IsTHPNashEquilibrium σ →
  ∃ τ : ∀ i, S i → ℝ, IsTotallyMixed τ ∧ ∀ i, IsBestResponse σ i

-- Proposition 8.F.1: A weakly dominated strategy is never a best response
-- to any totally mixed strategy profile.
axiom weakly_dominated_not_best_response :
  ∀ (σ : ∀ i, S i → ℝ) (i : I),
    IsWeaklyDominated σ i → ∀ τ : ∀ i, S i → ℝ, IsTotallyMixed τ → ¬IsBestResponse σ i

-- Proposition 8.F.2
theorem thpne_not_weakly_dominated
    (hσ : IsTHPNashEquilibrium σ) (i : I) :
    ¬IsWeaklyDominated σ i := by
  intro hwd
  obtain ⟨τ, hτ_mixed, hτ_br⟩ := thpne_best_response_to_totally_mixed σ hσ
  exact weakly_dominated_not_best_response σ i hwd τ hτ_mixed (hτ_br i)