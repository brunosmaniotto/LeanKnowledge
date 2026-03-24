import Mathlib
open BigOperators

/-- The Scitovsky contour set: given `J` consumers and `L` commodities,
    with individual preference relations `pref_i` and reference consumptions `x̄_i`,
    this is the set of aggregate bundles `x = Σ_i x_i` such that each `x_i ≿_i x̄_i`
    and all components are nonneg. The boundary of this set is the Scitovsky contour. -/
noncomputable def ScitovskyScitovskyContourSet
    (L : ℕ) (J : ℕ)
    (pref : Fin J → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (x_bar : Fin J → (Fin L → ℝ)) :
    Set (Fin L → ℝ) :=
  { x : Fin L → ℝ |
    ∃ (alloc : Fin J → (Fin L → ℝ)),
      (∀ l : Fin L, x l = ∑ j : Fin J, alloc j l) ∧
      (∀ j : Fin J, pref j (alloc j) (x_bar j)) ∧
      (∀ j : Fin J, ∀ l : Fin L, 0 ≤ alloc j l) }