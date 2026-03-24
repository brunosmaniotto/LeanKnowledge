import Mathlib

open Finset BigOperators

/-- Production set: y₀ ≤ 0 and y₁ ≤ 1 -/
def Y_5Fc : Set (Fin 2 → ℝ) :=
  { y | y 0 ≤ 0 ∧ y 1 ≤ 1 }

/-- The inefficient point -/
noncomputable def y_star : Fin 2 → ℝ := ![(-1 : ℝ), 1]

/-- The dominating point -/
noncomputable def y_dom : Fin 2 → ℝ := ![(0 : ℝ), 1]

/-- Price vector with a zero component -/
noncomputable def p_5Fc : Fin 2 → ℝ := ![(0 : ℝ), 1]