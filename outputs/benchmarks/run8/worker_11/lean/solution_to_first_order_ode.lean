import Mathlib

open Set MeasureTheory

theorem Solution_to_First_Order_ODE
    (y : ℝ → ℝ) (f : ℝ → ℝ → ℝ) (a x : ℝ)
    (h_deriv : ∀ t ∈ uIcc a x, HasDerivAt y (f t (y t)) t)
    (h_cont : ContinuousOn (fun t => f t (y t)) (uIcc a x)) :
    y x = y a + ∫ t in a..x, f t (y t) := by
  have h_integrable : IntervalIntegrable (fun t => f t (y t)) volume a x :=
    h_cont.intervalIntegrable
  have h_ftc := intervalIntegral.integral_eq_sub_of_hasDerivAt h_deriv h_integrable
  linarith [h_ftc]