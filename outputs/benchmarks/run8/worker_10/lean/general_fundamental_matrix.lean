import Mathlib

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A matrix function `Φ` is a fundamental matrix for the linear ODE `x' = A(t) x` if
    it is differentiable and satisfies `Φ'(t) = A(t) * Φ(t)` and is nonsingular for every `t`. -/
def IsFundamentalMatrix (A : ℝ → Matrix n n ℝ) (Φ : ℝ → Matrix n n ℝ) : Prop :=
  (∀ t, HasDerivAt Φ (A t * Φ t) t) ∧ (∀ t, det (Φ t) ≠ 0)