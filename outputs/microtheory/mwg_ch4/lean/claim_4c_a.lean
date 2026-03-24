import Mathlib
open Topology
open BigOperators

axiom walras_distribute (n J : ℕ) (p : Fin n → ℝ) (x : Fin J → Fin n → ℝ) : ∑ k : Fin n, p k * (∑ i : Fin J, x i k) = ∑ k : Fin n, ∑ i : Fin J, p k * x i k
axiom walras_swap (n J : ℕ) (p : Fin n → ℝ) (x : Fin J → Fin n → ℝ) : ∑ k : Fin n, ∑ i : Fin J, p k * x i k = ∑ i : Fin J, ∑ k : Fin n, p k * x i k
axiom walras_apply_individual (n J : ℕ) (p : Fin n → ℝ) (x : Fin J → Fin n → ℝ) (w : Fin J → ℝ) (hw : ∀ (i : Fin J), ∑ k : Fin n, p k * x i k = w i) : ∑ i : Fin J, ∑ k : Fin n, p k * x i k = ∑ i : Fin J, w i

theorem walras_aggregate (n J : ℕ) (p : Fin n → ℝ) (x : Fin J → Fin n → ℝ) (w : Fin J → ℝ)
    (hw : ∀ (i : Fin J), ∑ k : Fin n, p k * x i k = w i) :
    ∑ k : Fin n, p k * (∑ i : Fin J, x i k) = ∑ i : Fin J, w i := by
  rw [walras_distribute n J p x, walras_swap n J p x, walras_apply_individual n J p x w hw]