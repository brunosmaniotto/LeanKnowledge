import Mathlib

open Matrix Finset BigOperators
open Topology

variable {n : ℕ}

/-- Mitiushin-Polterovich quotient equals zero when utility is homogeneous of degree one.
    By Euler's theorem, D²u(x)·x = 0 for degree-1 homogeneous functions,
    so the numerator xᵀ D²u(x) x = 0. -/
theorem mitiushin_polterovich_zero
    (x : Fin n → ℝ)
    (Du : Fin n → ℝ)           -- gradient ∇u(x)
    (D2u : Matrix (Fin n) (Fin n) ℝ)  -- Hessian D²u(x)
    (hEuler : D2u.mulVec x = 0)       -- Euler's theorem consequence for deg-1
    (hgrad_pos : 0 < x ⬝ᵥ Du)         -- x · ∇u(x) > 0 (monotonicity)
    : (x ⬝ᵥ (D2u.mulVec x)) / (x ⬝ᵥ Du) = 0 := by
  simp [hEuler, dotProduct_zero]