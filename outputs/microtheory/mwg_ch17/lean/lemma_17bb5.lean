import Mathlib

open Convex Set

theorem Lemma_17BB5
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (p : E →ₗ[ℝ] ℝ)
    (w : ℝ)
    (pref : E → E → Prop)
    (h_pref_convex : ∀ x y z : E, ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
      pref x z → pref y z → pref (α • x + (1 - α) • y) z)
    (h_pref_total : ∀ x y : E, pref x y ∨ pref y x)
    (χ : Set E)
    (hχ_def : χ = {x | p x ≤ w ∧ ∀ x', p x' ≤ w → pref x x'}) :
    Convex ℝ χ := by
  rw [hχ_def]
  intro x hx y hy α β hα hβ hαβ
  simp only [Set.mem_setOf_eq] at *
  refine ⟨?_, ?_⟩
  · have h1 : p (α • x + β • y) = α * p x + β * p y := by
      simp [map_add, map_smul]
    have h2 : α * p x ≤ α * w := mul_le_mul_of_nonneg_left hx.1 hα
    have h3 : β * p y ≤ β * w := mul_le_mul_of_nonneg_left hy.1 hβ
    have h4 : α * w + β * w = w := by rw [← add_mul, hαβ, one_mul]
    linarith
  · intro x' hx'
    have hβeq : β = 1 - α := by linarith
    subst hβeq
    exact h_pref_convex x y x' α hα (by linarith) (hx.2 x' hx') (hy.2 x' hx')