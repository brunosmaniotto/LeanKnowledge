import Mathlib
open Topology

/-- For a CRS production function (Euler's theorem: f₁x₁ + f₂x₂ = f),
    if the average product of x₁ is rising (MP₁·x₁ > f), then MP₂ < 0. -/
theorem Exercise_3_2
    (f₁ f₂ f_val x₁ x₂ : ℝ)
    (hx₂ : x₂ > 0)
    (euler : f₁ * x₁ + f₂ * x₂ = f_val)
    (ap_rising : f₁ * x₁ > f_val) :
    f₂ < 0 := by
  nlinarith