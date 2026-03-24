import Mathlib

open Matrix

/-- The Slutsky (substitution) matrix S(p, w) for a demand function x.
    Entry (l, k) is: ∂xₗ/∂pₖ + (∂xₗ/∂w) · xₖ(p, w).
    Equivalently, S(p, w) = Dₚ x(p, w) + Dw x(p, w) · x(p, w)ᵀ. -/
noncomputable def slutskyMatrix
    (L : ℕ)
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ)
    (w : ℝ) : Matrix (Fin L) (Fin L) ℝ :=
  Matrix.of fun l k =>
    -- ∂xₗ/∂pₖ: partial derivative of x_l w.r.t. price k
    deriv (fun t => x (Function.update p k t) w l) (p k)
    +
    -- (∂xₗ/∂w) · xₖ(p, w): wealth effect times current consumption of k
    deriv (fun t => x p t l) w * x p w k