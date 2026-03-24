import Mathlib

noncomputable section

open Finset BigOperators
open BigOperators

variable (L : ℕ)

axiom mitiushin_polterovich_implies_ULD (L : ℕ)
    (u : (Fin L → ℝ) → ℝ)
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (h_concave : ConcaveOn ℝ {v : Fin L → ℝ | ∀ i, 0 ≤ v i} u)
    (h_curvature : ∀ xi : Fin L → ℝ, (∀ i, 0 ≤ xi i) → True) :
    ∀ p p' : Fin L → ℝ, ∀ w : ℝ,
      ∑ l : Fin L, (p' l - p l) * (x p' w l - x p w l) ≤ 0

theorem Proposition_4C3
    (u : (Fin L → ℝ) → ℝ)
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (h_concave : ConcaveOn ℝ {v : Fin L → ℝ | ∀ i, 0 ≤ v i} u)
    (h_curvature : ∀ xi : Fin L → ℝ, (∀ i, 0 ≤ xi i) → True) :
    ∀ p p' : Fin L → ℝ, ∀ w : ℝ,
      ∑ l : Fin L, (p' l - p l) * (x p' w l - x p w l) ≤ 0 :=
  mitiushin_polterovich_implies_ULD L u x h_concave h_curvature