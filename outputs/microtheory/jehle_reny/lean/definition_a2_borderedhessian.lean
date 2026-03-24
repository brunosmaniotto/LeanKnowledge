import Mathlib
open Matrix

/-- The bordered Hessian of the Lagrangian for a two-variable, one-constraint problem.
    H̄ = [[0, g₁, g₂], [g₁, L₁₁, L₁₂], [g₂, L₁₂, L₂₂]].
    It is "bordered" because the Hessian of L is bordered by constraint partials and a zero. -/
def Definition_A2_BorderedHessian
    {R : Type*} [CommRing R]
    (g1 g2 L11 L12 L22 : R) : Matrix (Fin 3) (Fin 3) R :=
  !![0, g1, g2; g1, L11, L12; g2, L12, L22]