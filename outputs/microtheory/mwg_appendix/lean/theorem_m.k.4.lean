import Mathlib

open Set

/-- A function is strictly quasiconcave on a convex set if for any two distinct points
    with f(x) ≥ min(f(x), f(x')), the strict inequality holds at convex combinations. -/
theorem Theorem_M_K_4
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    {C : Set E} (hC : Convex ℝ C)
    {f : E → ℝ}
    (hf : ∀ x ∈ C, ∀ y ∈ C, x ≠ y → ∀ α : ℝ, 0 < α → α < 1 →
      f (α • x + (1 - α) • y) > min (f x) (f y))
    {x : E} (hx : x ∈ C) (hx_max : ∀ y ∈ C, f y ≤ f x)
    {x' : E} (hx' : x' ∈ C) (hx'_max : ∀ y ∈ C, f y ≤ f x')
    : x = x' := by
  by_contra hne
  have h_eq : f x = f x' := le_antisymm (hx'_max x hx) (hx_max x' hx')
  set α : ℝ := (1 : ℝ) / 2
  have hα_pos : (0 : ℝ) < α := by norm_num
  have hα_lt : α < (1 : ℝ) := by norm_num
  have hx'' : α • x + (1 - α) • x' ∈ C := hC hx hx' (le_of_lt hα_pos) (by linarith) (by ring)
  have hstrict := hf x hx x' hx' hne α hα_pos hα_lt
  have hle : f (α • x + (1 - α) • x') ≤ f x := hx_max _ hx''
  have : min (f x) (f x') = f x := by rw [h_eq]; simp [min_self]
  linarith