import Mathlib

open BigOperators
open Topology

theorem zero_profit_under_CRS
    {n : ℕ} (Y : Set (Fin n → ℝ)) (p : Fin n → ℝ)
    (cone : ∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y)
    (zero_mem : (0 : Fin n → ℝ) ∈ Y)
    (y_opt : Fin n → ℝ) (hy : y_opt ∈ Y)
    (profit_max : ∀ y ∈ Y, ∑ i, p i * y i ≤ ∑ i, p i * y_opt i)
    : ∑ i, p i * y_opt i = 0 := by
  have h0 : ∑ i, p i * (0 : Fin n → ℝ) i ≤ ∑ i, p i * y_opt i := profit_max 0 zero_mem
  simp at h0
  have h2 := cone y_opt hy 2 (by norm_num)
  have h3 := profit_max (2 • y_opt) h2
  simp only [Pi.smul_apply, smul_eq_mul] at h3
  have key : ∑ x, p x * (2 * y_opt x) = 2 * ∑ x, p x * y_opt x := by
    rw [Finset.mul_sum]
    congr 1
    ext i
    ring
  linarith