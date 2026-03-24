import Mathlib
open BigOperators

noncomputable def walrasianDemand (L : ℕ) (u : (Fin L → ℝ) → ℝ)
    (p : Fin L → ℝ) (w : ℝ) : Set (Fin L → ℝ) :=
  {x : Fin L → ℝ |
    (∀ i, 0 ≤ x i) ∧
    (∑ i, p i * x i ≤ w) ∧
    (∀ y : Fin L → ℝ,
      (∀ i, 0 ≤ y i) →
      (∑ i, p i * y i ≤ w) →
      u y ≤ u x)}