import Mathlib

variable {E : Type*} [AddCommGroup E] [Module ℝ E]

theorem hyperplanes_and_halfspaces_convex (f : E →ₗ[ℝ] ℝ) (c : ℝ) :
    Convex ℝ {x : E | f x = c} ∧
    Convex ℝ {x : E | f x ≤ c} ∧
    Convex ℝ {x : E | f x ≥ c} := by
  refine ⟨?_, ?_, ?_⟩
  · intro x hx y hy a b ha hb hab
    simp only [Set.mem_setOf_eq] at *
    simp only [map_add, map_smul, smul_eq_mul]
    rw [hx, hy]
    linear_combination c * hab
  · intro x hx y hy a b ha hb hab
    simp only [Set.mem_setOf_eq] at *
    simp only [map_add, map_smul, smul_eq_mul]
    have h1 : a * f x ≤ a * c := mul_le_mul_of_nonneg_left hx ha
    have h2 : b * f y ≤ b * c := mul_le_mul_of_nonneg_left hy hb
    have h3 : a * c + b * c = c := by linear_combination c * hab
    linarith
  · intro x hx y hy a b ha hb hab
    simp only [Set.mem_setOf_eq] at *
    simp only [map_add, map_smul, smul_eq_mul]
    have h1 : a * c ≤ a * f x := mul_le_mul_of_nonneg_left hx ha
    have h2 : b * c ≤ b * f y := mul_le_mul_of_nonneg_left hy hb
    have h3 : a * c + b * c = c := by linear_combination c * hab
    linarith