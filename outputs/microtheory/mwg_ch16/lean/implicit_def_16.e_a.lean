import Mathlib
open BigOperators

noncomputable def utilityPossibilitySet
    {I : ℕ} {J : ℕ} {L : ℕ}
    (X : Fin I → Set (Fin L → ℝ))
    (Y : Fin J → Set (Fin L → ℝ))
    (ω : Fin L → ℝ)
    (u : Fin I → (Fin L → ℝ) → ℝ) :
    Set (Fin I → ℝ) :=
  {v : Fin I → ℝ |
    ∃ (x : Fin I → Fin L → ℝ) (y : Fin J → Fin L → ℝ),
      (∀ i, x i ∈ X i) ∧
      (∀ j, y j ∈ Y j) ∧
      (∀ l, (∑ i, x i l) ≤ (∑ j, y j l) + ω l) ∧
      (∀ i, v i ≤ u i (x i))}