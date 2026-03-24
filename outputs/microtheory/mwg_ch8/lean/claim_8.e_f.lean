import Mathlib

open BigOperators

/--
  A pure strategy Bayesian Nash equilibrium of a Bayesian game with correlated types
  induces a correlated equilibrium of the underlying complete information game.

  Formally: given BNE (each type's strategy is a pointwise best response), the
  joint distribution over action profiles induced by σ₁, σ₂ satisfies the
  correlated equilibrium obedience condition for player 1.

  Player 2's condition is symmetric.
-/
theorem bne_induces_correlated_equilibrium
    {A₁ A₂ T₁ T₂ : Type*}
    [Fintype A₁] [Fintype A₂] [Fintype T₁] [Fintype T₂]
    -- Player 1's utility in the complete information game
    (u₁ : A₁ → A₂ → ℝ)
    -- Correlated joint type distribution (need not be a product measure)
    (μ : T₁ × T₂ → ℝ)
    -- Pure strategies: maps from types to actions
    (σ₁ : T₁ → A₁) (σ₂ : T₂ → A₂)
    -- Bayesian Nash equilibrium: σ₁(t₁) is a best response for every type t₁
    -- (interim optimality: conditional on own type, no profitable deviation)
    (hBNE : ∀ (t₁ : T₁) (a₁' : A₁),
        ∑ t₂ : T₂, μ (t₁, t₂) * u₁ (σ₁ t₁) (σ₂ t₂) ≥
        ∑ t₂ : T₂, μ (t₁, t₂) * u₁ a₁' (σ₂ t₂))
    -- Arbitrary deviation function (maps recommended action to alternative)
    (f₁ : A₁ → A₁) :
    -- Correlated equilibrium obedience: ex-ante, following the recommendation σ₁(t₁)
    -- weakly dominates any deviation f₁(σ₁(t₁))
    ∑ t : T₁ × T₂, μ t * u₁ (σ₁ t.1) (σ₂ t.2) ≥
    ∑ t : T₁ × T₂, μ t * u₁ (f₁ (σ₁ t.1)) (σ₂ t.2) := by
  -- Rewrite both product-type sums as iterated sums over T₁, then T₂
  simp_rw [Fintype.sum_prod_type]
  -- Reduce to pointwise inequality for each t₁ (sum monotonicity)
  apply Finset.sum_le_sum
  intro t₁ _
  -- For this t₁, BNE gives that σ₁(t₁) beats any deviation, including f₁(σ₁(t₁))
  exact hBNE t₁ (f₁ (σ₁ t₁))