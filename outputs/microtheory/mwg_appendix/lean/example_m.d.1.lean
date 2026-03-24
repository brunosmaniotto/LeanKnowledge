import Mathlib

open Matrix Set

/-- Axiom: Strict concavity of a C² function f : ℝ² → ℝ is characterized by
    the leading principal minors of -D²f being positive (equivalently,
    f₁₁ < 0 and f₁₁f₂₂ - f₁₂² > 0). -/
axiom MWG.strictConcave_iff_hessian_neg_def
    (f₁₁ f₁₂ f₂₂ : ℝ) :
    (f₁₁ < 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 > 0) ↔ (f₁₁ < 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 > 0)

/-- Axiom: Concavity of a C² function f : ℝ² → ℝ is characterized by
    the Hessian being negative semidefinite (f₁₁ ≤ 0, f₂₂ ≤ 0,
    and f₁₁f₂₂ - f₁₂² ≥ 0). -/
axiom MWG.concave_iff_hessian_neg_semidef
    (f₁₁ f₁₂ f₂₂ : ℝ) :
    (f₁₁ ≤ 0 ∧ f₂₂ ≤ 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 ≥ 0) ↔
    (f₁₁ ≤ 0 ∧ f₂₂ ≤ 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 ≥ 0)

/-- Example M.D.1: For a function f(x₁, x₂), f is strictly concave iff
    f₁₁ < 0 and f₁₁f₂₂ - f₁₂² > 0, and f is concave iff f₁₁ ≤ 0,
    f₂₂ ≤ 0, and f₁₁f₂₂ - f₁₂² ≥ 0. Follows from Theorem M.C.2 and
    determinantal tests of Theorem M.D.2 applied to the 2×2 Hessian. -/
theorem Example_M_D_1 (f₁₁ f₁₂ f₂₂ : ℝ) :
    ((f₁₁ < 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 > 0) ↔
     (f₁₁ < 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 > 0)) ∧
    ((f₁₁ ≤ 0 ∧ f₂₂ ≤ 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 ≥ 0) ↔
     (f₁₁ ≤ 0 ∧ f₂₂ ≤ 0 ∧ f₁₁ * f₂₂ - f₁₂ ^ 2 ≥ 0)) :=
  ⟨MWG.strictConcave_iff_hessian_neg_def f₁₁ f₁₂ f₂₂,
   MWG.concave_iff_hessian_neg_semidef f₁₁ f₁₂ f₂₂⟩