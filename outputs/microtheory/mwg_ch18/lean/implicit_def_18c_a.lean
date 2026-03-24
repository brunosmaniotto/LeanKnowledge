import Mathlib

noncomputable def effectiveBudgetSet
    {I L : ℕ}
    (A : Fin I → Type*)
    (ω : Fin I → Fin L → ℝ)
    (g : (i : Fin I) → A i → (Fin L → ℝ) → Fin L → ℝ)
    (p : (i : Fin I) → A i → (∀ j, j ≠ i → A j) → Fin L → ℝ)
    (i : Fin I)
    (a_neg_i : ∀ j, j ≠ i → A j) :
    Set (Fin L → ℝ) :=
  {x_i | ∃ a'_i : A i, ∀ l : Fin L,
    x_i l - ω i l ≤ g i a'_i (p i a'_i a_neg_i) l}