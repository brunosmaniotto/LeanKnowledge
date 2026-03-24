import Mathlib

/-- A social welfare function W : (Fin I → ℝ) → ℝ satisfies the Paretian property
    if it is increasing: weak dominance implies weak inequality of welfare,
    and strict dominance implies strict inequality of welfare. -/
structure IsParetian {I : ℕ} (W : (Fin I → ℝ) → ℝ) : Prop where
  weak : ∀ u u' : Fin I → ℝ, (∀ i, u i ≤ u' i) → W u ≤ W u'
  strict : ∀ u u' : Fin I → ℝ, (∀ i, u i < u' i) → W u < W u'

/-- A social welfare function W is strictly Paretian if it is strictly increasing:
    if u'ᵢ ≥ uᵢ for all i and u'ᵢ > uᵢ for at least one i, then W(u') > W(u). -/
structure IsStrictlyParetian {I : ℕ} (W : (Fin I → ℝ) → ℝ) : Prop where
  strict : ∀ u u' : Fin I → ℝ, (∀ i, u i ≤ u' i) → (∃ i, u i < u' i) → W u < W u'