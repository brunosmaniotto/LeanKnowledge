import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem utilitarian_from_separability_and_common_origin_invariance
    {n : ℕ} (hn : 0 < n)
    (b : Fin n → ℝ)
    (W : (Fin n → ℝ) → ℝ)
    (hW : W = fun u => ∑ i : Fin n, b i * u i) :
    ∀ (c : ℝ) (u : Fin n → ℝ),
      W (fun i => u i + c) = W u + c * ∑ i : Fin n, b i := by
  intro c u
  simp only [hW]
  simp [mul_add, Finset.sum_add_distrib, Finset.mul_sum, mul_comm]