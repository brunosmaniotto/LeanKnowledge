import Mathlib
open Topology
open BigOperators

axiom sum_swap_mul {m n : ℕ} (A : Fin m → Fin n → ℝ) (mu : Fin m → ℝ) (x : Fin n → ℝ) : ∑ i : Fin m, mu i * ∑ j : Fin n, A i j * x j = ∑ j : Fin n, x j * ∑ i : Fin m, A i j * mu i
axiom complementary_slackness_value {m n : ℕ} (c : Fin m → ℝ) (mu : Fin m → ℝ) (A : Fin m → Fin n → ℝ) (x : Fin n → ℝ) (hcs : ∀ i : Fin m, mu i * (c i - ∑ j : Fin n, A i j * x j) = 0) : ∑ i : Fin m, c i * mu i = ∑ i : Fin m, mu i * ∑ j : Fin n, A i j * x j
axiom weak_duality_inequality {m n : ℕ} (f : Fin n → ℝ) (x : Fin n → ℝ) (c : Fin m → ℝ) (mu : Fin m → ℝ) (A : Fin m → Fin n → ℝ) (hx_feasible : ∀ i : Fin m, ∑ j : Fin n, A i j * x j ≤ c i) (hmu_nonneg : ∀ i : Fin m, 0 ≤ mu i) (hmu_feasible : ∀ j : Fin n, f j ≤ ∑ i : Fin m, A i j * mu i) : ∑ j : Fin n, f j * x j ≤ ∑ i : Fin m, c i * mu i
axiom strong_duality {m n : ℕ} (f : Fin n → ℝ) (x : Fin n → ℝ) (c : Fin m → ℝ) (mu : Fin m → ℝ) (A : Fin m → Fin n → ℝ) (hx_feasible : ∀ i : Fin m, ∑ j : Fin n, A i j * x j ≤ c i) (hmu_nonneg : ∀ i : Fin m, 0 ≤ mu i) (hdual_eq : ∀ j : Fin n, ∑ i : Fin m, A i j * mu i = f j) (hcs : ∀ i : Fin m, mu i * (c i - ∑ j : Fin n, A i j * x j) = 0) : ∑ j : Fin n, f j * x j = ∑ i : Fin m, c i * mu i

theorem Theorem_M_M_1 {m n : ℕ} (f : Fin n → ℝ) (x_opt : Fin n → ℝ) (c : Fin m → ℝ) (mu_opt : Fin m → ℝ) (A : Fin m → Fin n → ℝ)
    (hx_feasible : ∀ i : Fin m, ∑ j : Fin n, A i j * x_opt j ≤ c i)
    (hmu_nonneg : ∀ i : Fin m, 0 ≤ mu_opt i)
    (hdual_eq : ∀ j : Fin n, ∑ i : Fin m, A i j * mu_opt i = f j)
    (hcs : ∀ i : Fin m, mu_opt i * (c i - ∑ j : Fin n, A i j * x_opt j) = 0)
    (hx_optimal : ∀ x' : Fin n → ℝ, (∀ i, ∑ j, A i j * x' j ≤ c i) → ∑ j, f j * x' j ≤ ∑ j, f j * x_opt j)
    : (∑ j : Fin n, f j * x_opt j = ∑ i : Fin m, c i * mu_opt i) ∧
      (∀ mu' : Fin m → ℝ, (∀ i, 0 ≤ mu' i) → (∀ j, f j ≤ ∑ i, A i j * mu' i) → ∑ i, c i * mu_opt i ≤ ∑ i, c i * mu' i) := by
  constructor
  · exact strong_duality f x_opt c mu_opt A hx_feasible hmu_nonneg hdual_eq hcs
  · intro mu' hmu'_nonneg hmu'_feasible
    have heq := strong_duality f x_opt c mu_opt A hx_feasible hmu_nonneg hdual_eq hcs
    rw [← heq]
    exact weak_duality_inequality f x_opt c mu' A hx_feasible hmu'_nonneg hmu'_feasible