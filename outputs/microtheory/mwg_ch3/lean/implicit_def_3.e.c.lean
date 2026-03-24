import Mathlib
open Finset

noncomputable def hicksianDemand
    (L : ℕ)
    (u : (Fin L → ℝ) → ℝ)
    (p : Fin L → ℝ)
    (uBar : ℝ) : Set (Fin L → ℝ) :=
  {x : Fin L → ℝ |
    (∀ i, 0 ≤ x i) ∧
    u x ≥ uBar ∧
    (∀ y : Fin L → ℝ,
      (∀ i, 0 ≤ y i) →
      u y ≥ uBar →
      Finset.sum Finset.univ (fun i => p i * x i) ≤
        Finset.sum Finset.univ (fun i => p i * y i))}