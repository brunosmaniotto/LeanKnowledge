import Mathlib
open Matrix

theorem claim_A2_BorderedHessianDeterminant
    {R : Type*} [CommRing R]
    (g1 g2 L11 L12 L22 : R) :
    det !![0, g1, g2; g1, L11, L12; g2, L12, L22] =
    -(L11 * g2 ^ 2 - 2 * L12 * g1 * g2 + L22 * g1 ^ 2) := by
  simp [det_fin_three]
  ring