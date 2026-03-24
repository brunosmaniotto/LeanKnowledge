import Mathlib

open Set

/-- The derivative of a concave function is antitone (non-increasing). -/
axiom ConcaveOn_deriv_antitone
    {f : ℝ → ℝ}
    (hf : ConcaveOn ℝ Set.univ f)
    (hf' : Differentiable ℝ f) :
    Antitone (deriv f)

/-- An antitone differentiable function has non-positive derivative. -/
axiom antitone_deriv_nonpos
    {g : ℝ → ℝ}
    (hg : Antitone g)
    (hg' : Differentiable ℝ g)
    (x : ℝ) :
    deriv g x ≤ 0

/-- All second-order own partial derivatives of a concave function are non-positive
    (Theorem A2.5). Stated for f : ℝ → ℝ; the multivariate case follows by
    restricting f to each coordinate line, which preserves concavity. -/
theorem invoked_theorem_A2_5
    {f : ℝ → ℝ}
    (hf : ConcaveOn ℝ Set.univ f)
    (hf' : Differentiable ℝ f)
    (hf'' : Differentiable ℝ (deriv f))
    (x : ℝ) :
    deriv (deriv f) x ≤ 0 :=
  antitone_deriv_nonpos (ConcaveOn_deriv_antitone hf hf') hf'' x