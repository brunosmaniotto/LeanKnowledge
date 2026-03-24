import Mathlib

/-- Euler equation iteration model for capital accumulation. -/
structure EulerCapitalModel where
  A : Set (ℝ × ℝ)
  ψ : ℝ → ℝ
  isEulerSeq : ℝ → ℝ → (ℕ → ℝ) → Prop
  isBounded : (ℕ → ℝ) → Prop
  isStrictlyInterior : (ℕ → ℝ) → Prop
  /-- Prop 20.D.7: bounded interior Euler seq from k₀ is optimal -/
  prop_20D7 : ∀ k₀ k₁ seq, isEulerSeq k₀ k₁ seq → isBounded seq →
    isStrictlyInterior seq → k₁ = ψ k₀
  /-- Prop 20.D.6: uniqueness of optimal policy -/
  prop_20D6 : ∀ k₀, ∃! k₁, ∃ seq, isEulerSeq k₀ k₁ seq ∧
    isBounded seq ∧ isStrictlyInterior seq

/-- Case (3) of the Euler iteration occurs for at most one value of k₁,
    and that value equals ψ(k₀). -/
theorem euler_iteration_uniqueness (M : EulerCapitalModel) (k₀ k₁ k₁' : ℝ)
    (seq₁ seq₂ : ℕ → ℝ)
    (h1 : M.isEulerSeq k₀ k₁ seq₁) (hb1 : M.isBounded seq₁) (hi1 : M.isStrictlyInterior seq₁)
    (h2 : M.isEulerSeq k₀ k₁' seq₂) (hb2 : M.isBounded seq₂) (hi2 : M.isStrictlyInterior seq₂) :
    k₁ = k₁' ∧ k₁ = M.ψ k₀ := by
  constructor
  · have := M.prop_20D7 k₀ k₁ seq₁ h1 hb1 hi1
    have := M.prop_20D7 k₀ k₁' seq₂ h2 hb2 hi2
    linarith
  · exact M.prop_20D7 k₀ k₁ seq₁ h1 hb1 hi1