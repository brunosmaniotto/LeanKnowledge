import Mathlib

/-- Claim 5.3(b): Strict convexity of the production set ensures the profit-maximizing
    production plan is unique. -/
theorem Claim_5_3_b {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {Y : Set E} {f : E →L[ℝ] ℝ} {y₁ y₂ : E}
    (hsc : StrictConvex ℝ Y) (hf : f ≠ 0)
    (hy₁ : y₁ ∈ Y) (hy₂ : y₂ ∈ Y)
    (hmax₁ : ∀ y ∈ Y, f y ≤ f y₁)
    (hmax₂ : ∀ y ∈ Y, f y ≤ f y₂) :
    y₁ = y₂ := by
  by_contra hne
  have heq : f y₁ = f y₂ := le_antisymm (hmax₂ y₁ hy₁) (hmax₁ y₂ hy₂)
  have hmid : (1 / 2 : ℝ) • y₁ + (1 / 2 : ℝ) • y₂ ∈ interior Y :=
    hsc hy₁ hy₂ hne (by norm_num) (by norm_num) (by norm_num)
  have hfm : f ((1 / 2 : ℝ) • y₁ + (1 / 2 : ℝ) • y₂) = f y₁ := by
    simp only [map_add, map_smul, smul_eq_mul]; linarith
  have hlmax : IsLocalMax (⇑f) ((1 / 2 : ℝ) • y₁ + (1 / 2 : ℝ) • y₂) := by
    apply Filter.Eventually.mono (mem_interior_iff_mem_nhds.mp hmid)
    intro z hz; linarith [hmax₁ z hz]
  exact hf (hlmax.hasFDerivAt_eq_zero f.hasFDerivAt)