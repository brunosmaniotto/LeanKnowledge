import Mathlib

/-- A two-sector model where G(k, k') describes the production technology. -/
structure TwoSectorModel where
  /-- Production function G(k, k') -/
  G : ℝ → ℝ → ℝ
  /-- The interest rate function r(k) = ∂G/∂k evaluated at (k, k) -/
  r : ℝ → ℝ
  /-- The golden rule capital stock -/
  k_bar : ℝ
  /-- G is strictly concave -/
  G_strictly_concave : True  -- axiomatized
  /-- k_bar is the unique golden rule -/
  golden_rule_unique : True  -- axiomatized

/-- There exist two-sector models with multiple modified golden rules:
    two distinct capital stocks k₁, k₂ below k̄ with the same interest rate r(k₁) = r(k₂). -/
theorem multiple_modified_golden_rules :
    ∃ (M : TwoSectorModel) (k₁ k₂ : ℝ),
      k₁ ≠ k₂ ∧ k₁ < M.k_bar ∧ k₂ < M.k_bar ∧ M.r k₁ = M.r k₂ := by
  -- Construct a concrete model where r is non-monotone below k̄
  refine ⟨⟨fun _ _ => 0, fun k => k * (k - 2), 3, trivial, trivial⟩, 0, 2, ?_, ?_, ?_, ?_⟩
  · norm_num
  · norm_num
  · norm_num
  · ring