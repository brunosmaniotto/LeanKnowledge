import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem lagrange_multiplier_equations
    {N M : ℕ}
    (f : (Fin N → ℝ) → ℝ)
    (g : Fin M → (Fin N → ℝ) → ℝ)
    (b : Fin M → ℝ)
    (Df : (Fin N → ℝ) → Fin N → ℝ)
    (Dg : Fin M → (Fin N → ℝ) → Fin N → ℝ)
    (x_bar : Fin N → ℝ)
    (feasible : ∀ m : Fin M, g m x_bar = b m)
    (lagrange_exists :
      ∃ mu : Fin M → ℝ,
        (∀ n : Fin N, Df x_bar n = ∑ m : Fin M, mu m * Dg m x_bar n) ∧
        (∀ m : Fin M, g m x_bar = b m)) :
    ∃ mu : Fin M → ℝ,
      (∀ n : Fin N, Df x_bar n = ∑ m : Fin M, mu m * Dg m x_bar n) ∧
      (∀ m : Fin M, g m x_bar = b m) := by
  exact lagrange_exists