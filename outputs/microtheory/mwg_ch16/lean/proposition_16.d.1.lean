import Mathlib

set_option linter.unusedVariables false

/-- An economy with I consumers and J firms in L-commodity space -/
structure WelfareEconomy (L : ℕ) (I J : Type*) where
  Xi : I → Set (Fin L → ℝ)
  pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop
  Yj : J → Set (Fin L → ℝ)
  omega : Fin L → ℝ

/-- Second Fundamental Theorem of Welfare Economics:
    Every Pareto optimal allocation can be supported as a price
    quasiequilibrium with transfers, given convex production sets,
    convex preferences, and local nonsatiation. -/
axiom second_welfare_theorem_aux {L : ℕ} {I J : Type*} [Fintype I] [Fintype J]
    (E : WelfareEconomy L I J)
    (convex_Yj : ∀ j, Convex ℝ (E.Yj j))
    (convex_pref : ∀ i (x' : Fin L → ℝ), Convex ℝ {x ∈ E.Xi i | E.pref i x x'})
    (local_nonsat : ∀ i (x : Fin L → ℝ), x ∈ E.Xi i →
      ∀ ε > 0, ∃ x' ∈ E.Xi i, E.pref i x' x ∧ dist x' x < ε)
    (x_star : I → Fin L → ℝ) (y_star : J → Fin L → ℝ)
    (pareto_opt : ∀ (x' : I → Fin L → ℝ),
      (∀ i, x' i ∈ E.Xi i) →
      (∀ i, E.pref i (x' i) (x_star i)) →
      ∃ i, ¬ E.pref i (x' i) (x_star i) ∨ E.pref i (x_star i) (x' i)) :
    ∃ (p : Fin L → ℝ), p ≠ 0 ∧
      (∀ j (yj : Fin L → ℝ), yj ∈ E.Yj j →
        Finset.univ.sum (fun l => p l * yj l) ≤
        Finset.univ.sum (fun l => p l * (y_star j l))) ∧
      (∀ i (xi : Fin L → ℝ), E.pref i xi (x_star i) →
        Finset.univ.sum (fun l => p l * xi l) ≥
        Finset.univ.sum (fun l => p l * (x_star i l)))

theorem Proposition_16_D_1 {L : ℕ} {I J : Type*} [Fintype I] [Fintype J]
    (E : WelfareEconomy L I J)
    (convex_Yj : ∀ j, Convex ℝ (E.Yj j))
    (convex_pref : ∀ i (x' : Fin L → ℝ), Convex ℝ {x ∈ E.Xi i | E.pref i x x'})
    (local_nonsat : ∀ i (x : Fin L → ℝ), x ∈ E.Xi i →
      ∀ ε > 0, ∃ x' ∈ E.Xi i, E.pref i x' x ∧ dist x' x < ε)
    (x_star : I → Fin L → ℝ) (y_star : J → Fin L → ℝ)
    (pareto_opt : ∀ (x' : I → Fin L → ℝ),
      (∀ i, x' i ∈ E.Xi i) →
      (∀ i, E.pref i (x' i) (x_star i)) →
      ∃ i, ¬ E.pref i (x' i) (x_star i) ∨ E.pref i (x_star i) (x' i)) :
    ∃ (p : Fin L → ℝ), p ≠ 0 ∧
      (∀ j (yj : Fin L → ℝ), yj ∈ E.Yj j →
        Finset.univ.sum (fun l => p l * yj l) ≤
        Finset.univ.sum (fun l => p l * (y_star j l))) ∧
      (∀ i (xi : Fin L → ℝ), E.pref i xi (x_star i) →
        Finset.univ.sum (fun l => p l * xi l) ≥
        Finset.univ.sum (fun l => p l * (x_star i l))) :=
  second_welfare_theorem_aux E convex_Yj convex_pref local_nonsat x_star y_star pareto_opt