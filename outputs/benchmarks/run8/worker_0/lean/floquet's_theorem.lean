import Mathlib

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {𝕜 : Type*} [NontriviallyNormedField 𝕜] [NormedAlgebra ℝ 𝕜]

/-- A function Φ is a fundamental matrix for the system x' = A(t)x if it is differentiable
    and satisfies the ODE, and its determinant is a unit (so it is invertible). -/
def IsFundamentalMatrix (Φ : ℝ → Matrix n n 𝕜) (A : ℝ → Matrix n n 𝕜) : Prop :=
  (∀ t, HasDerivAt Φ (A t * Φ t) t) ∧ (∀ t, IsUnit (det (Φ t)))