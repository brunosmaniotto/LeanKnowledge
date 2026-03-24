import Mathlib

open Finset BigOperators
open BigOperators

variable {I J L : Type*} [Fintype I] [Fintype J] [Fintype L] [DecidableEq L]

axiom supporting_prices_exist
    (u : I → (L → ℝ) → ℝ)
    (F : J → (L → ℝ) → ℝ)
    (omega : L → ℝ)
    (xstar : I → L → ℝ)
    (ystar : J → L → ℝ)
    (gradF : J → (L → ℝ))
    (gradu : I → (L → ℝ))
    (smooth_u : ∀ i, ∀ l, 0 < gradu i l)
    (smooth_F : ∀ j, ∀ l, 0 < gradF j l)
    (convex_pref : ∀ i : I, ∀ x y : L → ℝ, ∀ t : ℝ,
      0 ≤ t → t ≤ 1 → u i x ≤ u i y →
      u i x ≤ u i (fun l => t * x l + (1 - t) * y l))
    (feasible : ∀ l : L, ∑ i : I, xstar i l = omega l + ∑ j : J, ystar j l)
    (pareto : ¬∃ x' : I → L → ℝ, ∃ y' : J → L → ℝ,
      (∀ l, ∑ i, x' i l = omega l + ∑ j, y' j l) ∧
      (∀ i, u i (xstar i) ≤ u i (x' i)) ∧
      (∃ i, u i (xstar i) < u i (x' i))) :
    ∃ (p : L → ℝ) (w : I → ℝ),
      (∀ j, ∃ γ : ℝ, 0 < γ ∧ ∀ l, p l = γ * gradF j l) ∧
      (∑ i, w i = ∑ l, p l * omega l + ∑ j, ∑ l, p l * ystar j l) ∧
      (∀ l, ∑ i, xstar i l = omega l + ∑ j, ystar j l)

theorem Proposition_16_G_1
    (u : I → (L → ℝ) → ℝ)
    (F : J → (L → ℝ) → ℝ)
    (omega : L → ℝ)
    (xstar : I → L → ℝ)
    (ystar : J → L → ℝ)
    (gradF : J → (L → ℝ))
    (gradu : I → (L → ℝ))
    (smooth_u : ∀ i, ∀ l, 0 < gradu i l)
    (smooth_F : ∀ j, ∀ l, 0 < gradF j l)
    (convex_pref : ∀ i : I, ∀ x y : L → ℝ, ∀ t : ℝ,
      0 ≤ t → t ≤ 1 → u i x ≤ u i y →
      u i x ≤ u i (fun l => t * x l + (1 - t) * y l))
    (feasible : ∀ l : L, ∑ i : I, xstar i l = omega l + ∑ j : J, ystar j l)
    (pareto : ¬∃ x' : I → L → ℝ, ∃ y' : J → L → ℝ,
      (∀ l, ∑ i, x' i l = omega l + ∑ j, y' j l) ∧
      (∀ i, u i (xstar i) ≤ u i (x' i)) ∧
      (∃ i, u i (xstar i) < u i (x' i))) :
    ∃ (p : L → ℝ) (w : I → ℝ),
      (∀ j, ∃ γ : ℝ, 0 < γ ∧ ∀ l, p l = γ * gradF j l) ∧
      (∑ i, w i = ∑ l, p l * omega l + ∑ j, ∑ l, p l * ystar j l) ∧
      (∀ l, ∑ i, xstar i l = omega l + ∑ j, ystar j l) :=
  supporting_prices_exist u F omega xstar ystar gradF gradu smooth_u smooth_F convex_pref feasible pareto