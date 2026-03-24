import Mathlib

theorem quasiconcave_of_convex_upper_contour
    {L : Type*} [Fintype L]
    (u : (L → ℝ) → ℝ)
    (h_convex : ∀ x : L → ℝ, Convex ℝ {y : L → ℝ | u y ≥ u x}) :
    ∀ (x y : L → ℝ) (α : ℝ), 0 ≤ α → α ≤ 1 →
      u (α • x + (1 - α) • y) ≥ min (u x) (u y) := by
  intro x y α hα0 hα1
  rcases le_total (u x) (u y) with hxy | hxy
  · -- Case: u x ≤ u y, so min = u x
    rw [min_eq_left hxy]
    have hx_mem : x ∈ {z : L → ℝ | u z ≥ u x} := by simp [Set.mem_setOf_eq]
    have hy_mem : y ∈ {z : L → ℝ | u z ≥ u x} := by simp [Set.mem_setOf_eq]; exact hxy
    exact h_convex x hx_mem hy_mem hα0 (sub_nonneg.mpr hα1) (by ring)
  · -- Case: u y ≤ u x, so min = u y
    rw [min_eq_right hxy]
    have hx_mem : x ∈ {z : L → ℝ | u z ≥ u y} := by simp [Set.mem_setOf_eq]; exact hxy
    have hy_mem : y ∈ {z : L → ℝ | u z ≥ u y} := by simp [Set.mem_setOf_eq]
    exact h_convex y hx_mem hy_mem hα0 (sub_nonneg.mpr hα1) (by ring)