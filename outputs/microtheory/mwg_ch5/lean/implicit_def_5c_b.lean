import Mathlib
open BigOperators

noncomputable def profit (L : ℕ) (p y : Fin L → ℝ) : ℝ :=
  ∑ ℓ : Fin L, p ℓ * y ℓ