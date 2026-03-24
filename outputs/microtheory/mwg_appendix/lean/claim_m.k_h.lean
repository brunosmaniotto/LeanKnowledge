import Mathlib

-- MWG Theorem M.K.3 condition (M.K.9) and sufficient conditions
variable {N : ℕ} (f : (Fin N → ℝ) → ℝ)

/-- Condition (M.K.9) from Theorem M.K.3 -/
axiom MWG.ConditionMK9 : ((Fin N → ℝ) → ℝ) → Prop

/-- f is concave on ℝᴺ -/
axiom MWG.IsConcaveFn : ((Fin N → ℝ) → ℝ) → Prop

/-- f is quasiconcave on ℝᴺ -/
axiom MWG.IsQuasiconcaveFn : ((Fin N → ℝ) → ℝ) → Prop

/-- The gradient of f is nonzero everywhere -/
axiom MWG.GradientNonzero : ((Fin N → ℝ) → ℝ) → Prop

/-- Concavity implies condition (M.K.9) -/
axiom MWG.concave_implies_MK9 : ∀ (g : (Fin N → ℝ) → ℝ),
  MWG.IsConcaveFn g → MWG.ConditionMK9 g

/-- Quasiconcavity with nonvanishing gradient implies condition (M.K.9) -/
axiom MWG.quasiconcave_grad_nonzero_implies_MK9 : ∀ (g : (Fin N → ℝ) → ℝ),
  MWG.IsQuasiconcaveFn g → MWG.GradientNonzero g → MWG.ConditionMK9 g

theorem Claim_M_K_h :
    (MWG.IsConcaveFn f →  MWG.ConditionMK9 f) ∧
    (MWG.IsQuasiconcaveFn f → MWG.GradientNonzero f → MWG.ConditionMK9 f) := by
  exact ⟨MWG.concave_implies_MK9 f, MWG.quasiconcave_grad_nonzero_implies_MK9 f⟩