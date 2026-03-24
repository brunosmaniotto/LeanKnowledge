import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem budget_set_convex
    {n : ℕ} (X : Set (Fin n → ℝ)) (p : Fin n → ℝ) (w : ℝ)
    (hX : Convex ℝ X) :
    Convex ℝ {x ∈ X | ∑ i, p i * x i ≤ w} := by
  intro x hx y hy a b ha hb hab
  refine ⟨hX hx.1 hy.1 ha hb hab, ?_⟩
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  have key : ∑ i, p i * (a * x i + b * y i) =
      a * (∑ i, p i * x i) + b * (∑ i, p i * y i) := by
    trans ∑ i, (a * (p i * x i) + b * (p i * y i))
    · exact Finset.sum_congr rfl fun i _ => by ring
    · simp [Finset.sum_add_distrib, ← Finset.mul_sum]
  rw [key]
  calc a * ∑ i, p i * x i + b * ∑ i, p i * y i
      ≤ a * w + b * w := add_le_add (mul_le_mul_of_nonneg_left hx.2 ha)
                                      (mul_le_mul_of_nonneg_left hy.2 hb)
    _ = w := by rw [← add_mul, hab, one_mul]