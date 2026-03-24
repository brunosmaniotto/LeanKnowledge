import Mathlib

theorem claim_1_3_d
    {E : Type*} [AddCommMonoid E] [Module ℝ E]
    {B : Set E} (hB : Convex ℝ B)
    {u : E → ℝ}
    (h_sqc : ∀ x ∈ B, ∀ y ∈ B, x ≠ y → u x ≥ u y →
      ∀ t : ℝ, 0 < t → t < 1 → u (t • x + (1 - t) • y) > u y)
    {x y : E} (hx : x ∈ B) (hy : y ∈ B)
    (hmax_x : ∀ z ∈ B, u z ≤ u x)
    (hmax_y : ∀ z ∈ B, u z ≤ u y) :
    x = y := by
  by_contra hne
  have heq : u x = u y := le_antisymm (hmax_y x hx) (hmax_x y hy)
  have hgt := h_sqc x hx y hy hne heq.ge (1 / 2 : ℝ) (by norm_num) (by norm_num)
  have hsub : ((1 : ℝ) - 1 / 2) = (1 : ℝ) / 2 := by norm_num
  rw [hsub] at hgt
  have hmem : ((1 : ℝ) / 2) • x + ((1 : ℝ) / 2) • y ∈ B :=
    hB hx hy (by norm_num) (by norm_num) (by norm_num)
  linarith [hmax_x _ hmem]