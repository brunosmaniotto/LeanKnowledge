import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Concavity of VNM utility u implies concavity of expected utility
    Σ pᵢ u(w + β rᵢ) in the portfolio weight β. -/
theorem expected_utility_concave_in_beta
    {n : ℕ} (p : Fin n → ℝ) (r : Fin n → ℝ) (w : ℝ)
    (u : ℝ → ℝ)
    (hp : ∀ i, 0 ≤ p i)
    (hu : ConcaveOn ℝ Set.univ u) :
    ConcaveOn ℝ Set.univ (fun β => ∑ i : Fin n, p i * u (w + β * r i)) := by
  constructor
  · exact convex_univ
  · intro x _ y _ a b ha hb hab
    simp only [smul_eq_mul]
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    apply Finset.sum_le_sum
    intro i _
    have hu_i := hu.2 (Set.mem_univ (w + x * r i)) (Set.mem_univ (w + y * r i)) ha hb hab
    simp only [smul_eq_mul] at hu_i
    have h_aff : a * (w + x * r i) + b * (w + y * r i) = w + (a * x + b * y) * r i := by
      have h1 : a * (w + x * r i) + b * (w + y * r i) =
        (a + b) * w + (a * x + b * y) * r i := by ring
      rw [h1, hab, one_mul]
    rw [h_aff] at hu_i
    calc a * (p i * u (w + x * r i)) + b * (p i * u (w + y * r i))
        = p i * (a * u (w + x * r i) + b * u (w + y * r i)) := by ring
      _ ≤ p i * u (w + (a * x + b * y) * r i) :=
          mul_le_mul_of_nonneg_left hu_i (hp i)