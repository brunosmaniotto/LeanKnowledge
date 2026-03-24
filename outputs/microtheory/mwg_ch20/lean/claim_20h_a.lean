import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem bubbles_impossible_finite_consumers
    {n : ℕ}
    (hn : 0 < n)
    (endowment profit consumption : Fin n → ℝ)
    (M : ℝ)
    (h_wealth : ∀ i, consumption i = endowment i + profit i + M)
    (h_clearing : ∑ i, consumption i = ∑ i, (endowment i + profit i)) :
    M = 0 := by
  have h_rewrite : ∑ i, consumption i = ∑ i, (endowment i + profit i) + ↑n * M := by
    conv_lhs => arg 2; ext i; rw [h_wealth i]
    simp [Finset.sum_add_distrib, Finset.sum_const, nsmul_eq_mul]
  have h_nM : ↑n * M = 0 := by linarith
  have h_n_pos : (↑n : ℝ) ≠ 0 := by positivity
  exact (mul_eq_zero.mp h_nM).resolve_left h_n_pos