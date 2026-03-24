import Mathlib

theorem Compensatory_Distortion_22B2
    (dx1dp2 dx2dp2 : ℝ)
    (pbar1 p2star : ℝ)
    (hpbar1 : pbar1 > 1)
    (W : ℝ → ℝ)
    (hW_deriv : HasDerivAt W ((pbar1 - 1) * dx1dp2 + (p2star - 1) * dx2dp2) p2star)
    (hmax : IsLocalMax W p2star) :
    (pbar1 - 1) * dx1dp2 + (p2star - 1) * dx2dp2 = 0 :=
  hmax.hasDerivAt_eq_zero hW_deriv