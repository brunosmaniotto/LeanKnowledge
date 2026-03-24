import Mathlib

variable {E : Type*} [AddCommGroup E] [Module ℝ E]

theorem hyperplanes_and_halfspaces_convex (f : E →ₗ[ℝ] ℝ) (c : ℝ) :
    Convex ℝ {x : E | f x = c} ∧
    Convex ℝ {x : E | f x ≤ c} ∧
    Convex ℝ {x : E | f x ≥ c} := by
  have lin : ∀ (a b : ℝ) (x y : E), f (a • x + b • y) = a * f x + b * f y := by
    intros a b x y; simp [map_add, map_smul]
  refine ⟨?_, ?_, ?_⟩
  · intro x hx y hy a b ha hb hab
    simp only [Set.mem_setOf_eq] at *
    rw [lin, hx, hy, ← add_mul, hab, one_mul]
  · intro x hx y hy a b ha hb hab
    simp only [Set.mem_setOf_eq] at *
    rw [lin]
    calc a * f x + b * f y
        ≤ a * c + b * c := by linarith [mul_le_mul_of_nonneg_left hx ha, mul_le_mul_of_nonneg_left hy hb]
      _ = c := by rw [← add_mul, hab, one_mul]
  · intro x hx y hy a b ha hb hab
    simp only [Set.mem_setOf_eq] at *
    rw [lin]
    calc c = a * c + b * c := by rw [← add_mul, hab, one_mul]
      _ ≤ a * f x + b * f y := by linarith [mul_le_mul_of_nonneg_left hx ha, mul_le_mul_of_nonneg_left hy hb]