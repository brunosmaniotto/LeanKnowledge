import Mathlib

variable {X : Type*} [AddCommGroup X] [Module ℝ X]

/-- Equal Treatment in the Core (Theorem 5.16, MWG):
    In the core of E₂, consumers of the same type receive identical bundles.
    Two types (I=2), two consumers per type (r=2). -/
theorem Theorem_5_16
    (pref₁ pref₂ : X → X → Prop)
    (x11 x12 x21 x22 e1 e2 : X)
    -- Strict convexity of ≿₁: if a ≿₁ b and a ≠ b, midpoint ≻₁ b
    (strict_conv₁ : ∀ a b : X, pref₁ a b → a ≠ b →
      pref₁ ((2 : ℝ)⁻¹ • (a + b)) b ∧ ¬ pref₁ b ((2 : ℝ)⁻¹ • (a + b)))
    -- Convexity of ≿₂: if a ≿₂ b, midpoint ≿₂ b
    (conv₂ : ∀ a b : X, pref₂ a b →
      pref₂ ((2 : ℝ)⁻¹ • (a + b)) b)
    -- Feasibility: total allocation = total endowment in E₂
    (feasible : x11 + x12 + (x21 + x22) = (2 : ℝ) • (e1 + e2))
    -- Core: coalition {consumer 12, consumer 22} cannot block
    (core : ∀ y1 y2 : X, y1 + y2 = e1 + e2 →
      ¬ (pref₁ y1 x12 ∧ ¬ pref₁ x12 y1 ∧ pref₂ y2 x22))
    -- WLOG from completeness: x11 ≿₁ x12, x21 ≿₂ x22
    (h₁ : pref₁ x11 x12)
    (h₂ : pref₂ x21 x22) : x11 = x12 := by
  by_contra h_ne
  -- Coalition {12, 22} blocks with midpoints x̄₁₂ = (x11+x12)/2, x̄₂₂ = (x21+x22)/2
  have h2 : (2 : ℝ) ≠ 0 := by norm_num
  exact core _ _
    -- Feasibility: x̄₁₂ + x̄₂₂ = ½(x11+x12+x21+x22) = ½·2(e1+e2) = e1+e2
    (by rw [← smul_add, feasible, inv_smul_smul₀ h2])
    -- Blocking: x̄₁₂ ≻₁ x12 (strict convexity + h_ne) and x̄₂₂ ≿₂ x22 (convexity)
    ⟨(strict_conv₁ x11 x12 h₁ h_ne).1,
     (strict_conv₁ x11 x12 h₁ h_ne).2,
     conv₂ x21 x22 h₂⟩