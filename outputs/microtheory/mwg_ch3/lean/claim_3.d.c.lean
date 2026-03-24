import Mathlib

open BigOperators
open Topology

theorem lagrange_multiplier_marginal_utility_of_wealth
    {n : ℕ}
    (grad_u : Fin n → ℝ)
    (p : Fin n → ℝ)
    (Dw_x : Fin n → ℝ)
    (lam : ℝ)
    (foc : grad_u = fun i => lam * p i)
    (walras_diff : ∑ i : Fin n, p i * Dw_x i = 1)
    : ∑ i : Fin n, grad_u i * Dw_x i = lam := by
  subst foc
  simp only []
  conv_lhs => arg 2; ext i; rw [mul_assoc]
  rw [← Finset.mul_sum]
  rw [walras_diff, mul_one]