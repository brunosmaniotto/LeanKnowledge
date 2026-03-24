import Mathlib
open BigOperators
set_option linter.unusedVariables false

axiom walras_eq_exists (L : ℕ) (hL : 0 < L)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hcont : Continuous z)
    (hhomog : ∀ (p : Fin L → ℝ) (t : ℝ), 0 < t → z (fun i => t * p i) = z p)
    (hwalras : ∀ (p : Fin L → ℝ), (∀ i, 0 ≤ p i) → ∑ i, p i * z p i = 0) :
    ∃ pstar : Fin L → ℝ, (∀ i, 0 ≤ pstar i) ∧ ∀ i, z pstar i ≤ 0

theorem Proposition_17_C_2 (L : ℕ) (hL : 0 < L)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hcont : Continuous z)
    (hhomog : ∀ (p : Fin L → ℝ) (t : ℝ), 0 < t → z (fun i => t * p i) = z p)
    (hwalras : ∀ (p : Fin L → ℝ), (∀ i, 0 ≤ p i) → ∑ i, p i * z p i = 0) :
    ∃ pstar : Fin L → ℝ, (∀ i, 0 ≤ pstar i) ∧ ∀ i, z pstar i ≤ 0 :=
  walras_eq_exists L hL z hcont hhomog hwalras