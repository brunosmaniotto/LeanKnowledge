import Mathlib

open Finset BigOperators
open BigOperators

theorem budget_set_convex (L : ℕ) (p w : ℝ) (x x' : Fin L → ℝ)
    (α : ℝ) (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (hx : ∑ i : Fin L, p * x i ≤ w)
    (hx' : ∑ i : Fin L, p * x' i ≤ w) :
    ∑ i : Fin L, p * (α * x i + (1 - α) * x' i) ≤ w := by
  have h1α : 0 ≤ 1 - α := by linarith
  have key : ∑ i : Fin L, p * (α * x i + (1 - α) * x' i) =
    α * (∑ i : Fin L, p * x i) + (1 - α) * (∑ i : Fin L, p * x' i) := by
    simp only [mul_add, Finset.sum_add_distrib, ← Finset.mul_sum]
    ring
  rw [key]
  calc α * (∑ i : Fin L, p * x i) + (1 - α) * (∑ i : Fin L, p * x' i)
      ≤ α * w + (1 - α) * w := by gcongr
    _ = w := by ring