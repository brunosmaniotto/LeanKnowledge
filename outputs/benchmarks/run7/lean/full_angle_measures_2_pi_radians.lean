import Mathlib

open Real

theorem FullAngleMeasures2PiRadians : ((2 * π : ℝ) : Real.Angle) = 0 :=
  Real.Angle.coe_two_pi