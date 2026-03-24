import Mathlib
open Topology

theorem Equation_Vickrey3_p33_15
    (a : ℝ) (Z1 Z2 : ℝ → ℝ)
    (h : ∀ X, Z1 X * Z2 X = X ^ 2 - a * X + (Z1 0 * Z2 0)) :
    ∃ k : ℝ, ∀ X, Z1 X * Z2 X = X ^ 2 - a * X + k := by
  exact ⟨Z1 0 * Z2 0, h⟩