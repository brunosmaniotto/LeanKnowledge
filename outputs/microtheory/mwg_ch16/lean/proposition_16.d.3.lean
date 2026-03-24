import Mathlib
open BigOperators

/-- A price quasiequilibrium with transfers where all wealth transfers are strictly positive
    is a price equilibrium with transfers.

    The key insight: if wᵢ > 0 for every consumer i, then 0 ∈ Xᵢ satisfies p · 0 = 0 < wᵢ,
    providing a "cheaper consumption" for each consumer. By Proposition 16.D.2, the
    quasiequilibrium condition upgrades to the full equilibrium condition. -/
theorem Proposition_16_D_3
    {I : Type*} [Fintype I] [Nonempty I]
    {L : Type*} [Fintype L]
    (X : I → Set (L → ℝ))
    (pref : I → (L → ℝ) → (L → ℝ) → Prop)
    (p : L → ℝ)
    (x_hat : I → L → ℝ)
    (w : I → ℝ)
    -- X_i is convex and contains 0
    (hX_zero : ∀ i, (fun _ : L => (0 : ℝ)) ∈ X i)
    (hX_convex : ∀ i, Convex ℝ (X i))
    -- Budget feasibility: p · x̂_i = w_i
    (h_budget : ∀ i, ∑ l : L, p l * x_hat i l = w i)
    -- Preferences are continuous (captured abstractly)
    (h_cont : ∀ i, ∀ x ∈ X i, pref i x (x_hat i) → ∑ l : L, p l * x l ≥ w i)
    -- Quasiequilibrium: preferred bundles cost at least w_i
    -- All wealth transfers are strictly positive
    (hw_pos : ∀ i, w i > 0)
    -- Proposition 16.D.2: if there exists a cheaper point in X_i,
    -- then quasiequilibrium implies equilibrium for consumer i
    (prop_16_D_2 : ∀ i, (∃ z ∈ X i, ∑ l : L, p l * z l < w i) →
      (∀ x ∈ X i, pref i x (x_hat i) → ∑ l : L, p l * x l > w i))
    -- Conclusion: this is a price equilibrium with transfers
    : ∀ i, ∀ x ∈ X i, pref i x (x_hat i) → ∑ l : L, p l * x l > w i := by
  intro i
  apply prop_16_D_2 i
  refine ⟨fun _ => 0, hX_zero i, ?_⟩
  simp only [mul_zero, Finset.sum_const_zero]
  exact hw_pos i