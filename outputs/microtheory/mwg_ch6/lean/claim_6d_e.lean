import Mathlib

open MeasureTheory Set

/-- If F and G are two CDFs on [0, x̄] with the same mean and F(x̄) = G(x̄) = 1,
    then ∫ x in 0..x̄, (F x - G x) = 0. -/
theorem claim_6D_e
    (F G : ℝ → ℝ)
    (x_bar : ℝ)
    (hx_bar_pos : 0 ≤ x_bar)
    (hF_int : IntervalIntegrable F MeasureTheory.MeasureSpace.volume 0 x_bar)
    (hG_int : IntervalIntegrable G MeasureTheory.MeasureSpace.volume 0 x_bar)
    (h_equal_means : ∫ x in (0)..x_bar, F x = ∫ x in (0)..x_bar, G x) :
    ∫ x in (0)..x_bar, (F x - G x) = 0 := by
  rw [intervalIntegral.integral_sub hF_int hG_int]
  linarith