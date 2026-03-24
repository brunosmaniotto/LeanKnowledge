import Mathlib

open Set

theorem quasiconcave_iff_min_property
    {V : Type*} [AddCommMonoid V] [Module ℝ V]
    {A : Set V} (hA : Convex ℝ A)
    {f : V → ℝ} :
    (∀ x ∈ A, ∀ y ∈ A, ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
      f (α • x + (1 - α) • y) ≥ min (f x) (f y)) ↔
    (∀ t : ℝ, Convex ℝ {x ∈ A | t ≤ f x}) := by
  constructor
  · intro hmin t x ⟨hxA, hxf⟩ y ⟨hyA, hyf⟩ α β hα hβ hαβ
    refine ⟨hA hxA hyA hα hβ hαβ, ?_⟩
    have hα1 : α ≤ 1 := by linarith
    have hβeq : β = 1 - α := by linarith
    rw [hβeq]
    calc t ≤ min (f x) (f y) := le_min hxf hyf
      _ ≤ f (α • x + (1 - α) • y) := hmin x hxA y hyA α hα hα1
  · intro hconv x hxA y hyA α hα hα1
    have hβ : 0 ≤ 1 - α := by linarith
    have hαβ : α + (1 - α) = 1 := by ring
    let t := min (f x) (f y)
    have hx_mem : x ∈ {x ∈ A | t ≤ f x} := ⟨hxA, min_le_left _ _⟩
    have hy_mem : y ∈ {x ∈ A | t ≤ f x} := ⟨hyA, min_le_right _ _⟩
    exact (hconv t hx_mem hy_mem hα hβ hαβ).2