import Mathlib

open Finset BigOperators
open BigOperators

/-- The derived utility function w(x) from Definition 2.1.2.
    Given an expenditure function `e(p, u)`, define
    `w(x) = sup {u ≥ 0 | p · x ≥ e(p, u) for all p ≫ 0}`. -/
noncomputable def derivedUtilityW {L : ℕ}
    (e : (Fin L → ℝ) → ℝ → ℝ)
    (x : Fin L → ℝ) : ℝ :=
  sSup {u : ℝ | 0 ≤ u ∧
    ∀ p : Fin L → ℝ, (∀ i, 0 < p i) → ∑ i : Fin L, p i * x i ≥ e p u}