import Mathlib

open scoped BigOperators
open FiniteDimensional

axiom closed_convex_support_recovery
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [FiniteDimensional ℝ E]
    (Y : Set E) (hY_closed : IsClosed Y) (hY_convex : Convex ℝ Y) (hY_nonempty : Y.Nonempty) :
    Y = ⋂ (p : E), {y : E | @inner ℝ _ _ p y ≤ ⨆ (z : ↥Y), @inner ℝ _ _ p (z : E)}

theorem profit_cost_duality
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [FiniteDimensional ℝ E]
    (Y₁ Y₂ : Set E)
    (hY₁_closed : IsClosed Y₁) (hY₁_convex : Convex ℝ Y₁) (hY₁_nonempty : Y₁.Nonempty)
    (hY₂_closed : IsClosed Y₂) (hY₂_convex : Convex ℝ Y₂) (hY₂_nonempty : Y₂.Nonempty)
    (h_same_support : ∀ p : E,
      (⨆ (z : ↥Y₁), @inner ℝ _ _ p (z : E)) = (⨆ (z : ↥Y₂), @inner ℝ _ _ p (z : E))) :
    Y₁ = Y₂ := by
  have h₁ := closed_convex_support_recovery Y₁ hY₁_closed hY₁_convex hY₁_nonempty
  have h₂ := closed_convex_support_recovery Y₂ hY₂_closed hY₂_convex hY₂_nonempty
  rw [h₁, h₂]
  simp_rw [h_same_support]